# VeriRAG Backend Service

FastAPI-powered enterprise RAG backend with strict employee authentication, RBAC permission filtering, and verifiable evidence synthesis.

---

## Key Features

1. **Enterprise Directory Authentication**:
   - Validates logins directly against `data/employees/employees.xlsx` using OpenPyXL / Pandas.
   - Zero public signups or unverified self-registration.
   - Generates tamper-proof HS256 JWT sessions.
2. **Permission Guardrails (RBAC)**:
   - Filters candidate chunks before retrieval and scoring.
   - Tiers: `FULL`, `FINANCE`, `HR`, `PUBLIC`.
3. **8-Stage RAG Pipeline**:
   - Query Analysis → RBAC Check → BM25 Keyword Search → Dense Vector Search → Hybrid Fusion → Reranker → Grounded Synthesis → Claim Extraction & Verification → Conflict Detection → Confidence Scoring.
4. **Zero-Hallucination Abstention**:
   - Explicitly abstains (`INSUFFICIENT_EVIDENCE`) when no corroborating facts exist in authorized documents.

---

## Running the Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Interactive Swagger API Documentation: `http://localhost:8000/docs`
