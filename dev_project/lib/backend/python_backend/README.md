# CredyNox Backend

Base backend para el MVP fintech de CredyNox.

## Stack

- FastAPI
- Pydantic
- Supabase config
- Python 3.12

## Simulation Engine

El backend incluye un simulation engine en memoria con persistencia opcional en Supabase.

Simula:

- salary events,
- expense events,
- automation runs,
- timeline dinámica,
- dashboard reactivo,
- balance, liquidez y riesgo.

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
- `POST /simulate/salary`
- `POST /simulate/expense`
- `POST /automation/run`
- `GET /health`

## Pruebas rápidas

```bash
curl -X POST http://127.0.0.1:8000/simulate/salary \
	-H 'Content-Type: application/json' \
	-d '{"amount":2500,"reserve_amount":400,"source":"Salary detected"}'

curl -X POST http://127.0.0.1:8000/simulate/expense \
	-H 'Content-Type: application/json' \
	-d '{"amount":180,"category":"expense","description":"Expense detected"}'

curl -X POST http://127.0.0.1:8000/automation/run \
	-H 'Content-Type: application/json' \
	-d '{"trigger":"manual"}'
```

Swagger queda disponible en `/docs`.
