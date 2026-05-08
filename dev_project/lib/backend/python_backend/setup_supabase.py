#!/usr/bin/env python3
"""
Script to configure Supabase for the CredyNox backend.

This script loads .env automatically, validates the connection, prints the
SQL schema that must be run in Supabase SQL Editor, and seeds data only when
the tables already exist.
"""

from __future__ import annotations

import os
import sys

from dotenv import load_dotenv
from supabase import create_client


SCHEMA_SQL = """
create table if not exists users (
  id bigint primary key,
  name text,
  balance numeric,
  protected_funds numeric,
  available_liquidity numeric,
  risk_score int
);

create table if not exists transactions (
  id bigint primary key,
  type text,
  amount numeric,
  date timestamptz,
  user_id bigint
);

create table if not exists automation_events (
  id bigint primary key,
  action text,
  status text,
  timestamp timestamptz,
  meta jsonb
);
""".strip()


def load_environment() -> None:
    load_dotenv()
    base_dir = os.path.dirname(os.path.abspath(__file__))
    load_dotenv(os.path.join(base_dir, ".env"))
    load_dotenv(os.path.join(base_dir, ".env.local"))


def get_supabase_client():
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_ANON_KEY")

    if not supabase_url or not supabase_key:
        print("ERROR: SUPABASE_URL or SUPABASE_ANON_KEY not set in environment")
        print("\nExpected .env file next to this script with at least:")
        print("SUPABASE_URL=https://<project-ref>.supabase.co")
        print("SUPABASE_ANON_KEY=<anon-key>")
        sys.exit(1)

    try:
        client = create_client(supabase_url, supabase_key)
    except Exception as exc:
        print(f"ERROR: Failed to connect to Supabase: {exc}")
        sys.exit(1)

    print(f"✓ Connected to Supabase: {supabase_url}")
    return client


def get_admin_supabase_client():
    supabase_url = os.getenv("SUPABASE_URL")
    service_role_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

    if not supabase_url or not service_role_key:
        return None

    try:
        return create_client(supabase_url, service_role_key)
    except Exception:
        return None


def table_exists(client, table_name: str) -> bool:
    try:
        client.table(table_name).select("id").limit(1).execute()
        return True
    except Exception:
        return False


def seed_data(client) -> None:
    client.table("users").upsert(
        {
            "id": 1,
            "name": "Test User",
            "balance": 1200,
            "protected_funds": 400,
            "available_liquidity": 300,
            "risk_score": 12,
        }
    ).execute()
    print("✓ Inserted user data")

    transactions = [
        {
            "id": 1,
            "type": "income",
            "amount": 1500.0,
            "date": "2026-05-01T09:15:00Z",
            "user_id": 1,
        },
        {
            "id": 2,
            "type": "reserve",
            "amount": -400.0,
            "date": "2026-05-02T10:30:00Z",
            "user_id": 1,
        },
        {
            "id": 3,
            "type": "expense",
            "amount": -300.0,
            "date": "2026-05-04T14:00:00Z",
            "user_id": 1,
        },
    ]
    for transaction in transactions:
        client.table("transactions").upsert(transaction).execute()
    print("✓ Inserted transaction data")

    events = [
        {
            "id": 1,
            "action": "Protected funds recalculated",
            "status": "completed",
            "timestamp": "2026-05-04T08:00:00Z",
        },
        {
            "id": 2,
            "action": "Liquidity risk evaluated",
            "status": "completed",
            "timestamp": "2026-05-05T08:30:00Z",
        },
        {
            "id": 3,
            "action": "Rule sync queued",
            "status": "pending",
            "timestamp": "2026-05-08T07:45:00Z",
        },
    ]
    for event in events:
        client.table("automation_events").upsert(event).execute()
    print("✓ Inserted automation event data")


def seed_data_with_fallback(client) -> None:
    try:
        seed_data(client)
        return
    except Exception as exc:
        error_message = str(exc).lower()
        if "row-level security" not in error_message and "42501" not in error_message:
            raise

        admin_client = get_admin_supabase_client()
        if admin_client is None:
            print("\nSeed failed because RLS is enabled and SUPABASE_SERVICE_ROLE_KEY is not set.")
            print("Add SUPABASE_SERVICE_ROLE_KEY to .env, then rerun this script.")
            return

        print("\nRLS blocked inserts with anon key, retrying with service role key...")
        seed_data(admin_client)


def setup_supabase() -> None:
    load_environment()
    client = get_supabase_client()

    print("\nIf you need the schema, run this SQL in Supabase SQL Editor:\n")
    print(SCHEMA_SQL)

    missing_tables = [
        table_name
        for table_name in ("users", "transactions", "automation_events")
        if not table_exists(client, table_name)
    ]

    if missing_tables:
        print("\nMissing tables detected:", ", ".join(missing_tables))
        print("Run the SQL above in Supabase SQL Editor, then rerun this script.")
        return

    print("\nAll tables exist. Seeding sample data...")
    seed_data_with_fallback(client)
    print("\n✅ Supabase configuration complete!")


if __name__ == "__main__":
    setup_supabase()
