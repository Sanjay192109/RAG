-- ====================================================================
-- VERIRAG Seed Data (PostgreSQL)
-- ====================================================================

-- 1. Initial Document Catalog
INSERT INTO documents (id, title, source_name, source_type, file_path, department, access_level, version, document_date, chunk_count, status)
VALUES
('doc-001', 'Annual Report 2025', 'Annual_Report_2025.pdf', 'pdf', 'data/documents/pdf/Annual_Report_2025.pdf', 'Finance', 'FINANCE', 'v1', '2025-03-31', 2, 'INDEXED'),
('doc-002', 'Annual Report 2026', 'Annual_Report_2026.pdf', 'pdf', 'data/documents/pdf/Annual_Report_2026.pdf', 'Finance', 'FINANCE', 'v2', '2026-03-31', 1, 'INDEXED'),
('doc-003', 'Chennai Branch Revenue Breakdown', 'Chennai_Revenue.xlsx', 'excel', 'data/documents/excel/Chennai_Revenue.xlsx', 'Finance', 'FINANCE', 'v2', '2025-12-31', 5, 'INDEXED'),
('doc-004', 'Bangalore Branch Revenue Breakdown', 'Bangalore_Revenue.xlsx', 'excel', 'data/documents/excel/Bangalore_Revenue.xlsx', 'Finance', 'FINANCE', 'v2', '2026-03-31', 5, 'INDEXED'),
('doc-005', 'Employee Leave Policy 2025', 'Leave_Policy_2025.pdf', 'pdf', 'data/documents/pdf/Leave_Policy_2025.pdf', 'Human Resources', 'HR', 'v1', '2025-01-01', 1, 'INDEXED'),
('doc-006', 'Employee Leave Policy 2026 (Latest)', 'Leave_Policy_2026.pdf', 'pdf', 'data/documents/pdf/Leave_Policy_2026.pdf', 'Human Resources', 'HR', 'v2', '2026-01-01', 1, 'INDEXED'),
('doc-007', 'Global Code of Conduct & Workplace Guidelines', 'Employee_Policy.pdf', 'pdf', 'data/documents/pdf/Employee_Policy.pdf', 'Operations', 'PUBLIC', 'v1', '2025-01-15', 1, 'INDEXED'),
('doc-008', 'Executive Salary Compensation & Budget 2026', 'Financial_Forecast.pdf', 'pdf', 'data/documents/pdf/Financial_Forecast.pdf', 'Finance', 'FINANCE', 'v3', '2026-02-15', 1, 'INDEXED'),
('doc-009', 'Regional Sales Q1-Q4 Multi-City Report', 'regional_sales_2025.csv', 'csv', 'data/documents/csv/regional_sales_2025.csv', 'Finance', 'FINANCE', 'v1', '2025-12-31', 4, 'INDEXED'),
('doc-010', 'VeriRAG Corporate Governance FAQ Portal', 'company_faq.html', 'web', 'data/documents/web/company_faq.html', 'Operations', 'PUBLIC', 'v2', '2026-04-01', 2, 'INDEXED')
ON CONFLICT (id) DO NOTHING;
