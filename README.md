# Asiento Uno — servidor MCP del Registro Mercantil español

Datos del **BORME** (Boletín Oficial del Registro Mercantil) cruzados con
**subvenciones públicas (BDNS)** y **contratos públicos (PLACSP)**, por empresa,
con enlace al documento oficial de cada dato. Pensado para agentes de IA:
diligencia debida, KYB, verificación de proveedores y clientes.

- Endpoint remoto: `https://mcp.asientouno.com/mcp` (Streamable HTTP, JSON-RPC)
- Autenticación: `Authorization: Bearer <api_key>`
- Plan gratuito: 500 llamadas al día, 60 por minuto
- Web: https://asientouno.com/mcp · Precios: https://asientouno.com/precios

> **English**: MCP server for the Spanish Companies Registry gazette (BORME),
> joined with public grants (BDNS) and public procurement awards (PLACSP) per
> company. Every fact links to its official publication. Remote Streamable
> HTTP endpoint, Bearer API key, 500 calls/day on the free plan.

## Herramientas

| Herramienta | Qué devuelve |
|---|---|
| `asientouno_buscar_empresa` | Nombre o NIF → empresas coincidentes (con desambiguación: dice cuándo no está segura). |
| `asientouno_informe_completo` | Identificativos, órgano de administración vigente, actos recientes y señales de riesgo (concurso, disolución, extinción). |
| `asientouno_actos_borme` | Actos societarios paginados por cursor, cada uno con la URL oficial de su publicación en el BORME. |
| `asientouno_cargos_persona` | Nombre de persona → cargos vigentes e históricos y empresas vinculadas (el grafo de relaciones). |
| `asientouno_subvenciones_empresa` | Subvenciones registradas en la BDNS para la empresa. |
| `asientouno_contratos_empresa` | Adjudicaciones en la PLACSP para la empresa. |
| `asientouno_riesgo_empresa` | Concurso, disolución y extinción publicados en el BORME, con fecha y documento. |
| `asientouno_cuentas_anuales` | Responde `no_disponible_aun` cuando no hay dato: nunca inventa una cifra. |

Todas las herramientas son de solo lectura (`readOnlyHint: true`).

## Conseguir una API key

Escribe a través de https://asientouno.com/contacto indicando el caso de uso.
La clave llega por correo; no hay tarjeta ni contrato para el plan gratuito.

## Conectar

### Claude Desktop / Claude Code (vía `mcp-remote`)

`examples/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "asientouno": {
      "command": "npx",
      "args": [
        "-y", "mcp-remote",
        "https://mcp.asientouno.com/mcp",
        "--header", "Authorization: Bearer ${ASIENTOUNO_API_KEY}"
      ],
      "env": { "ASIENTOUNO_API_KEY": "tu_api_key" }
    }
  }
}
```

### Cualquier cliente MCP con transporte HTTP

```bash
curl -s https://mcp.asientouno.com/mcp \
  -H "Authorization: Bearer $ASIENTOUNO_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
```

Sin clave, el servidor responde `401` con el mensaje exacto de lo que falta.
`https://mcp.asientouno.com/health` es público y devuelve `{"estado":"ok"}`.

## Fuentes y límites, dichos claros

- BORME cargado desde marzo de 2024; BDNS desde 2022; PLACSP desde 2004.
- Una coincidencia por nombre no es una identificación: la búsqueda devuelve
  candidatos y `siguiente_paso` cuando hay ambigüedad.
- Nunca se afirma que una empresa esté sancionada por una coincidencia de
  nombre.
- Los nombres de personas físicas van parcialmente ofuscados en el plan
  gratuito; el nombre de una sociedad es público.

## Licencia

Este repositorio (documentación y ejemplos) es MIT. Los datos que sirve el
endpoint proceden de fuentes públicas (BOE, IGAE, Ministerio de Hacienda) y se
reutilizan conforme a la Ley 37/2007; cada respuesta enlaza a su publicación.
