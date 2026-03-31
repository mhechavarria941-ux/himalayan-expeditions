# Database Exploration Queries

This directory contains SQL queries used for exploring and analyzing the Himalayan Expeditions database.

## Files

### 01-schema-exploration.sql
Schema discovery and structure overview queries that provide:
- List of all tables in the database
- Sample SELECT queries (TOP 5 rows) from all 13 tables
- Quick way to understand database structure and data patterns

### 02-row-count-analysis.sql
Quick reference queries for data volume across all tables:
- Row count from each table sorted by volume
- Helps identify major tables and understand data distribution

### 03-data-dictionary-population.sql
Complete data dictionary with column descriptions:
- Comprehensive documentation of all columns across 13 tables
- Business-friendly descriptions for each column
- Can be used to populate the himalayan_data_dictionary table

## Database Tables

**Core Tables:**
- exped (11,425 rows): Main expedition records
- members (89,000 rows): Individual climber/participant records
- peaks (480 rows): Mountain reference data
- refer (15,586 rows): Source references and bibliography

**Detail Tables (linked to exped):**
- expedition_oxygen, expedition_style, expedition_timeline, expedition_statistics, expedition_admin, expedition_incidents, expedition_camps (11,425 rows each)

**Lookup Tables:**
- citizenship_lookup (247 rows)
- season_lookup (5 rows)
- himalayan_data_dictionary (221 rows)

## Usage

1. Run schema-exploration.sql for database overview
2. Check row-count-analysis.sql for data volume metrics
3. Execute data-dictionary-population.sql to populate schema documentation

