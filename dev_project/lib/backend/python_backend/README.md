# CredyNox Backend

Base backend para el MVP fintech de CredyNox.

## Stack

- FastAPI
- Pydantic
- Supabase config
- Python 3.12

## Estructura

- `app/main.py`: punto de entrada de FastAPI
- `app/routes/`: endpoints HTTP
- `app/services/`: lógica de negocio mock
- `app/models/`: modelos de dominio
- `app/schemas/`: contratos de respuesta
- `app/automation/`: futura automatización y reglas
- `app/banking/`: capa preparada para integraciones bancarias futuras

## Variables de entorno

Copia `.env.example` a `.env` y completa los valores necesarios.

## Ejecutar

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Endpoints

- `GET /dashboard`
- `GET /transactions`
- `GET /automation/timeline`
- `GET /health`

Swagger queda disponible en `/docs`.
