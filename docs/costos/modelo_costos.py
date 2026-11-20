"""Modelo de costos de Festa (SCRUM-131). Todos los supuestos están en SUPUESTOS y PRECIOS.

Sin capas gratuitas: cada recurso se cobra desde la primera unidad.
Precios consultados el 16-nov-2026 en las listas oficiales (ver PRECIOS[...]['fuente']).

Ingresos: el modelo oficial de monetización es el de `adjuntos/documentos/2026-11-16_festa-pg-ia-swnt-costos.xlsm`
(suscripción Festa Pro con cupo de IA y overage). La comisión por boleta NO se modela: está fuera del modelo
oficial y sería un ingreso adicional (upside). Wompi sobre las suscripciones es costo de Festa.
"""
import math

HORAS_MES = 730
TRM = 3300  # COP por USD (TRM del 11-nov-2026: 3.297,07)

# ---------------------------------------------------------------- supuestos (los aprueba el equipo)
FASES = {
    "Fase 1 · Piloto ECI": dict(mau=4_000, organizadores=60, compras=200,
                                replicas_calientes=1, replicas_resto=1, rds="db.t3.micro", cache="cache.t3.micro"),
    "Fase 2 · Bogotá zonal": dict(mau=30_000, organizadores=250, compras=1_500,
                                  replicas_calientes=2, replicas_resto=1, rds="db.t3.medium", cache="cache.t3.small"),
    "Fase 3 · Ciudad": dict(mau=100_000, organizadores=1_000, compras=5_000,
                            replicas_calientes=4, replicas_resto=2, rds="db.t3.medium", cache="cache.t3.medium"),
}
USO = dict(
    sesiones_por_mau=6,          # DAU/MAU ~17,5 % (informe de viabilidad) -> ~6 aperturas al mes
    peticiones_por_sesion=30,    # login/refresh, mapa, búsqueda, detalle, perfil, bandeja
    mb_por_sesion=0.4,           # JSON; las imágenes se sirven por URL externa
    kb_log_por_peticion=1.0,     # una línea de log por petición y servicio que toca
    usuarios_chat=0.25,          # fracción de MAU que usa el asistente de IA
    mensajes_chat=4,             # mensajes al mes por usuario que usa el chat
    tokens_chat=(3_000, 500),    # entrada (prompt + candidatos), salida (incluye razonamiento)
    # Solicitudes de IA de los organizadores: se costean con el MISMO volumen que se factura en Festa Pro
    # (NEGOCIO['solicitudes_por_evento'] x eventos), con los tokens por solicitud del XLSM (hoja Supuestos_Festa).
    tokens_solicitud=(3_000, 300),
    peticiones_por_compra=20,
    mb_por_compra=0.1,
)
# Festa Pro (XLSM oficial, hojas Inputs y Supuestos_Festa): 1 usuario pago = 1 organizador o comercio.
NEGOCIO = dict(
    suscripcion_cop=79_000,           # plan Festa Pro por organizador al mes
    solicitudes_incluidas=150,        # cupo de IA incluido en el plan
    overage_cop=60,                   # por solicitud de IA sobre el cupo (2x su costo)
    eventos_por_organizador=4,        # un organizador típico publica ~4 eventos al mes
    solicitudes_por_evento=5 + 2 + 40 + 2,  # descripción + moderación + chat de asistentes + métricas
    wompi_pct=0.0265, wompi_fijo_cop=700, iva=0.19,
    cobros_wompi_por_organizador=1,   # suscripción y overage se cobran en un solo cargo mensual
    precio_boleta_cop=35_000,         # solo para el costo de Wompi de una boleta (lo paga el comprador)
)
# El tamaño de cada fase se da en organizadores; los eventos salen de ahí (4 por organizador).
for _f in FASES.values():
    _f["eventos"] = _f["organizadores"] * NEGOCIO["eventos_por_organizador"]

# ---------------------------------------------------------------- precios oficiales (USD)
P = {
    # AWS us-east-1, Price List API (publicación 2026-11-11)
    "fargate_vcpu_h": 0.04048, "fargate_gb_h": 0.004445, "ipv4_h": 0.005,
    "rds_h": {"db.t3.micro": 0.018, "db.t3.small": 0.036, "db.t3.medium": 0.072}, "rds_gp3_gb_mes": 0.115,
    "cache_h": {"cache.t3.micro": 0.017, "cache.t3.small": 0.034, "cache.t3.medium": 0.068},
    "alb_h": 0.0225, "alb_lcu_h": 0.008, "nlb_h": 0.0225, "nlb_lcu_h": 0.006,
    "apigw_millon": 1.00, "secreto_mes": 0.40, "logs_gb": 0.50, "logs_gb_mes": 0.03,
    "efs_gb_mes": 0.30, "egreso_gb": 0.09,
    # Externos
    "llm_in_millon": 0.30, "llm_out_millon": 2.50,   # gemini-3.5-flash-lite (reemplazo de 2.5-flash el 1-dic-2026)
    "mapbox_mau_mil": 4.00,                          # Maps SDKs for Mobile, banda 25.001-125.000 (sin la franja gratis)
}

# Tareas de Fargate del Terraform (festa-infra#15): vCPU, GB, si escala con la carga.
TAREAS = {
    "gateway": (0.25, 0.5, True), "auth": (0.5, 1, True), "user": (0.5, 1, True), "event": (0.25, 0.5, True),
    "booking": (0.25, 0.5, True), "payment": (0.25, 0.5, True), "ai": (0.25, 0.5, False),
    "notification": (0.25, 0.5, False), "analytics": (0.25, 0.5, False),
    "rabbitmq": (0.5, 1, None), "mongo": (0.25, 1, None),  # None: siempre 1 réplica
}


def fijo_aws(f):
    vcpu = gb = tareas = 0
    for _, (c, m, caliente) in TAREAS.items():
        n = 1 if caliente is None else (f["replicas_calientes"] if caliente else f["replicas_resto"])
        vcpu += c * n; gb += m * n; tareas += n
    h = dict(
        fargate=vcpu * P["fargate_vcpu_h"] + gb * P["fargate_gb_h"],
        ipv4=tareas * P["ipv4_h"],
        rds=P["rds_h"][f["rds"]],
        cache=P["cache_h"][f["cache"]],
        balanceadores=P["alb_h"] + P["nlb_h"],
    )
    mes = {k: v * HORAS_MES for k, v in h.items()}
    mes["almacenamiento"] = 20 * P["rds_gp3_gb_mes"] + 5 * P["efs_gb_mes"] + P["secreto_mes"]
    return mes, vcpu, gb, tareas


def trafico_sin_compra(f):
    """Costo mensual de los usuarios que solo navegan: mapa, búsqueda e IA."""
    mau = f["mau"]
    sesiones = mau * USO["sesiones_por_mau"]
    pet = sesiones * USO["peticiones_por_sesion"]
    gb = sesiones * USO["mb_por_sesion"] / 1024
    msgs = mau * USO["usuarios_chat"] * USO["mensajes_chat"]
    ti, to = USO["tokens_chat"]
    c = dict(
        api_gateway=pet / 1e6 * P["apigw_millon"],
        egreso=gb * P["egreso_gb"],
        logs=pet * USO["kb_log_por_peticion"] / 1024 / 1024 * (P["logs_gb"] + P["logs_gb_mes"]),
        lcu=(pet / (HORAS_MES * 3600) / 25 + gb / HORAS_MES) * HORAS_MES * (P["alb_lcu_h"] + P["nlb_lcu_h"]),
        ia_chat=msgs * (ti * P["llm_in_millon"] + to * P["llm_out_millon"]) / 1e6,
        mapbox=mau / 1000 * P["mapbox_mau_mil"],
    )
    return c, pet, gb


def costo_solicitud_usd():
    ti, to = USO["tokens_solicitud"]
    return (ti * P["llm_in_millon"] + to * P["llm_out_millon"]) / 1e6


def ia_organizadores(f):
    """Todas las solicitudes que se facturan (descripción, moderación, chat de asistentes y métricas)."""
    return f["eventos"] * NEGOCIO["solicitudes_por_evento"] * costo_solicitud_usd()


def por_compra_usd():
    pet = USO["peticiones_por_compra"]
    infra = pet / 1e6 * P["apigw_millon"] + USO["mb_por_compra"] / 1024 * P["egreso_gb"] \
        + pet * USO["kb_log_por_peticion"] / 1024 / 1024 * P["logs_gb"]
    b = NEGOCIO["precio_boleta_cop"]
    wompi_cop = (b * NEGOCIO["wompi_pct"] + NEGOCIO["wompi_fijo_cop"]) * (1 + NEGOCIO["iva"])
    return infra, wompi_cop


def festa_pro():
    """Economía de un organizador con Festa Pro al mes (COP): ARPU, Wompi del cobro y neto antes de costos fijos."""
    n = NEGOCIO
    solicitudes = n["eventos_por_organizador"] * n["solicitudes_por_evento"]
    overage = max(0, solicitudes - n["solicitudes_incluidas"]) * n["overage_cop"]
    arpu = n["suscripcion_cop"] + overage
    wompi = (arpu * n["wompi_pct"] + n["wompi_fijo_cop"]) * (1 + n["iva"]) * n["cobros_wompi_por_organizador"]
    return dict(solicitudes=solicitudes, overage=overage, arpu=arpu, wompi=wompi, neto=arpu - wompi)


def comparar_nubes_fase1():
    """Mismo inventario de la Fase 1 en las tres nubes, 730 h, sin capas gratuitas. USD/mes."""
    h = HORAS_MES
    app = {k: v for k, v in TAREAS.items() if v[2] is not None}  # 9 servicios HTTP
    vcpu_app = sum(c for c, _, _ in app.values()); gb_app = sum(m for _, m, _ in app.values())
    vcpu_all = vcpu_app + 0.75; gb_all = gb_app + 2  # + rabbitmq y mongo
    fijo, _, _, _ = fijo_aws(FASES["Fase 1 · Piloto ECI"])
    aws = sum(fijo.values())
    # Azure Container Apps (consumo, réplica mínima 1, siempre activa por los consumidores en segundo plano).
    azure = dict(
        contenedores=(vcpu_all * 0.000024 + gb_all * 0.000003) * 3600 * h,  # API Retail Prices, eastus
        postgres=0.017 * h + 20 * 0.115,  # Flexible Server B1MS + almacenamiento
        redis=0.022 * h,                  # Azure Cache for Redis Basic C0
    )
    # GCP: Cloud Run con facturación por instancia exige >= 1 vCPU por servicio; RabbitMQ y Mongo en una VM E2.
    gcp = dict(
        cloud_run=(len(app) * 1 * 0.000018 + gb_app * 0.000002) * 3600 * h,  # Cloud Billing Catalog, us-east1
        vm_rabbit_mongo=(0.021812 + 2 * 0.002924 + 0.005) * h,               # E2 1 vCPU + 2 GB + IP externa
        cloud_sql=0.0105 * h + 20 * 0.17,                                     # micro zonal + SSD
        memorystore=0.049 * h,                                                # Redis Basic M1 (1 GB)
    )
    return aws, azure, gcp


def fmt(x, d=2):
    return f"{x:,.{d}f}".replace(",", "X").replace(".", ",").replace("X", ".")


if __name__ == "__main__":
    infra_compra, wompi_boleta = por_compra_usd()
    pro = festa_pro()
    print(f"Por boleta: infraestructura USD {infra_compra:.6f}; Wompi {fmt(wompi_boleta,0)} COP (lo paga el comprador); sin comisión (fuera del modelo oficial)")
    print(f"Festa Pro por organizador: {pro['solicitudes']} solicitudes de IA, overage {fmt(pro['overage'],0)}; ARPU {fmt(pro['arpu'],0)} COP; "
          f"Wompi {fmt(pro['wompi'],0)} COP; neto {fmt(pro['neto'],0)} COP")
    print()
    for nombre, f in FASES.items():
        fijo, vcpu, gb, tareas = fijo_aws(f)
        sin, pet, gbx = trafico_sin_compra(f)
        desc = ia_organizadores(f)
        compras_usd = f["compras"] * infra_compra
        total_fijo = sum(fijo.values())
        total_var = sum(sin.values()) + desc + compras_usd
        total = total_fijo + total_var
        orgs = f["organizadores"]
        ingreso_cop = orgs * pro["arpu"]
        wompi_total_cop = orgs * pro["wompi"]
        margen_cop = ingreso_cop - wompi_total_cop - total * TRM
        equilibrio = math.ceil(total * TRM / pro["neto"])
        print(f"== {nombre}: {f['mau']} MAU, {orgs} organizadores, {f['eventos']} eventos, {tareas} tareas ({vcpu} vCPU, {gb} GB)")
        print("   fijo:", {k: round(v, 2) for k, v in fijo.items()}, "=", round(total_fijo, 2))
        print("   sin compra:", {k: round(v, 2) for k, v in sin.items()}, f"peticiones={pet:,.0f} GB={gbx:.1f}")
        print(f"   IA organizadores ({f['eventos'] * NEGOCIO['solicitudes_por_evento']:,} solicitudes a USD {costo_solicitud_usd():.5f})={desc:.2f} "
              f"compras={compras_usd:.4f}  variable={total_var:.2f}")
        print(f"   TOTAL USD {total:.2f}/mes = {fmt(total*TRM,0)} COP; por MAU USD {total/f['mau']:.4f}; "
              f"sin compra por MAU {sum(sin.values())/f['mau']:.4f}")
        print(f"   ingreso Festa Pro {fmt(ingreso_cop,0)} COP (USD {ingreso_cop/TRM:.2f}); Wompi {fmt(wompi_total_cop,0)} COP; "
              f"margen sobre operación {fmt(margen_cop,0)} COP (USD {margen_cop/TRM:.2f}); "
              f"ingreso por MAU USD {ingreso_cop/TRM/f['mau']:.4f}; organizadores para equilibrio de operación {equilibrio}")
        print()
    aws, az, gcp = comparar_nubes_fase1()
    print(f"Nubes Fase 1 (fijo): AWS {aws:.2f} | Azure {sum(az.values()):.2f} {[(k, round(v,2)) for k,v in az.items()]} "
          f"| GCP {sum(gcp.values()):.2f} {[(k, round(v,2)) for k,v in gcp.items()]}")
    fh = sum(fijo_aws(FASES['Fase 1 · Piloto ECI'])[0].values()) / HORAS_MES
    print(f"AWS Fase 1 por hora (fijo): {fh:.4f}; USD 50 del lab = {50/fh:.0f} h; desarrollo 4 h x 22 días = USD {fh*88:.2f}/mes")
