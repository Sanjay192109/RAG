-- ====================================================================
-- VERIRAG Database Schema (PostgreSQL)
-- Enterprise Multi-Source RAG Intelligence & Evidence Verification
-- ====================================================================

-- 1. Users Table (Synchronized / Session cache from Employee Directory)
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(64) PRIMARY KEY,
    employee_id VARCHAR(32) UNIQUE NOT NULL,
    name VARCHAR(128) NOT NULL,
    email VARCHAR(128) UNIQUE NOT NULL,
    department VARCHAR(64) NOT NULL,
    role VARCHAR(32) NOT NULL,            -- ADMIN, FINANCE, HR, EMPLOYEE
    access_level VARCHAR(32) NOT NULL,    -- FULL, FINANCE, HR, PUBLIC
    designation VARCHAR(128),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

-- 2. Documents Table
CREATE TABLE IF NOT EXISTS documents (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(32) NOT NULL,     -- pdf, excel, csv, web
    file_path TEXT,
    source_url TEXT,
    department VARCHAR(64) NOT NULL,
    access_level VARCHAR(32) NOT NULL,    -- FULL, FINANCE, HR, PUBLIC
    version VARCHAR(32) DEFAULT 'v1',
    document_date DATE,
    chunk_count INT DEFAULT 0,
    status VARCHAR(32) DEFAULT 'INDEXED', -- PENDING, INDEXED, FAILED
    file_size_bytes BIGINT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Document Chunks Table
CREATE TABLE IF NOT EXISTS document_chunks (
    id VARCHAR(64) PRIMARY KEY,
    document_id VARCHAR(64) NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index INT NOT NULL,
    text TEXT NOT NULL,
    page_number INT,
    sheet_name VARCHAR(128),
    row_number INT,
    source_url TEXT,
    department VARCHAR(64) NOT NULL,
    access_level VARCHAR(32) NOT NULL,
    document_date DATE,
    version VARCHAR(32),
    embedding_dim INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Queries (Audit History) Table
CREATE TABLE IF NOT EXISTS queries (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) REFERENCES users(id),
    user_email VARCHAR(128) NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    status VARCHAR(32) NOT NULL,          -- VERIFIED, PARTIALLY_VERIFIED, CONFLICT_DETECTED, INSUFFICIENT_EVIDENCE
    confidence_score FLOAT NOT NULL,      -- 0.0 to 100.0
    evidence_score_label VARCHAR(32),     -- Strong Evidence, Moderate Evidence, Weak Evidence, Insufficient Evidence
    abstention_triggered BOOLEAN DEFAULT FALSE,
    pipeline_execution_time_ms INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Query Claims Table (Decomposed Claims)
CREATE TABLE IF NOT EXISTS query_claims (
    id VARCHAR(64) PRIMARY KEY,
    query_id VARCHAR(64) NOT NULL REFERENCES queries(id) ON DELETE CASCADE,
    claim_text TEXT NOT NULL,
    status VARCHAR(32) NOT NULL,          -- SUPPORTED, PARTIALLY_SUPPORTED, UNSUPPORTED
    verification_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Citations Table
CREATE TABLE IF NOT EXISTS citations (
    id VARCHAR(64) PRIMARY KEY,
    query_id VARCHAR(64) NOT NULL REFERENCES queries(id) ON DELETE CASCADE,
    claim_id VARCHAR(64) REFERENCES query_claims(id) ON DELETE CASCADE,
    chunk_id VARCHAR(64) REFERENCES document_chunks(id),
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(32) NOT NULL,
    page_number INT,
    sheet_name VARCHAR(128),
    row_number INT,
    source_url TEXT,
    excerpt TEXT NOT NULL,
    relevance_score FLOAT,
    document_date DATE,
    version VARCHAR(32)
);

-- 7. Conflicts Table
CREATE TABLE IF NOT EXISTS conflicts (
    id VARCHAR(64) PRIMARY KEY,
    query_id VARCHAR(64) REFERENCES queries(id) ON DELETE CASCADE,
    topic VARCHAR(255) NOT NULL,
    source_a_name VARCHAR(255) NOT NULL,
    source_a_value TEXT NOT NULL,
    source_a_date DATE,
    source_a_version VARCHAR(32),
    source_b_name VARCHAR(255) NOT NULL,
    source_b_value TEXT NOT NULL,
    source_b_date DATE,
    source_b_version VARCHAR(32),
    resolution_note TEXT,
    is_superseded BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performant filtering
CREATE INDEX IF NOT EXISTS idx_chunks_access ON document_chunks(access_level);
CREATE INDEX IF NOT EXISTS idx_chunks_dept ON document_chunks(department);
CREATE INDEX IF NOT EXISTS idx_queries_user ON queries(user_email);
CREATE INDEX IF NOT EXISTS idx_queries_date ON queries(created_at);
