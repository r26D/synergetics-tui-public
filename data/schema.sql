-- Synergetics Dictionary SQLite Schema
-- Represents ~18,000+ dictionary cards, their content, and relationships.

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;

-- ============================================================================
-- List of Main File Indicators (principal indicators per volume; see front-matter)
-- ============================================================================
CREATE TABLE IF NOT EXISTS main_file_indicators (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL UNIQUE,   -- e.g. "Sequences: Metaphors", "Diagrams in This File"
    volume          INTEGER NOT NULL,       -- 1-4
    page            TEXT,                   -- Volume page reference from printed list (e.g. "607")
    sort_order      INTEGER NOT NULL DEFAULT 0
);

-- ============================================================================
-- Core card table: one row per card file (C00001.tex .. C21188.tex)
-- ============================================================================
CREATE TABLE IF NOT EXISTS cards (
    id              TEXT PRIMARY KEY,       -- 'C00001' through 'C21188', matches filename
    card_number     INTEGER NOT NULL,       -- Numeric portion (1-21188), for sorting
    title           TEXT NOT NULL,          -- From \section{...} e.g. "Acceleration: Angular and Linear Acceleration"
    letter_group    TEXT NOT NULL,          -- 'a'..'w', 'xyz'
    volume          INTEGER,               -- 1-4 based on letter range
    main_file_indicator_id INTEGER REFERENCES main_file_indicators(id),  -- When this card is the header for a main indicator
    card_type       TEXT NOT NULL           -- see docs-site/docs/card-types-inventory.md
                    CHECK(card_type IN (
                      'definition','text_citation','cross_reference','term',
                      'rbf_definitions','robert_marks_definition','ed_schlossberg_definition',
                      'text_citations','file_indicators','rbf_personal_references','rbf_quotation','named_quotation',
                      'bor_memorandum','synergetics_style_rule','tables','biblical_references','paired_citations',
                      'rbf_comments','eja_comments',
                      'letter_group_divider','index_entry'
                    )),
    reference_level INTEGER,               -- 0 = source; 1, 2, 3 from trailing (1)/(2)/(3); NULL if absent
    reference_level_label TEXT,            -- Display form e.g. '2B', '(A)' when not plain (1)/(2)/(3)
    content_text    TEXT,                   -- Full raw text inside verbatim/alltt block
    definition_text TEXT,                   -- Quoted definition portion only (definition cards)
    image_path      TEXT,                   -- 'content/images/cards/a/C00001'
    sort_order      INTEGER NOT NULL,       -- Global display order
    needs_review    INTEGER,                -- Boolean flag (0 or 1) indicating card needs review
    review_notes    TEXT,                   -- Explanation of why card needs review or what was fixed
    reviewed_at     DATETIME,               -- When card was reviewed from image (NULL = from .tex import only)
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- Alternate names for cards with multiple titles
-- e.g. card "Sewers" also known as "Sewage Systems"
-- ============================================================================
CREATE TABLE IF NOT EXISTS card_aliases (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    card_id     TEXT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    alias       TEXT NOT NULL,
    UNIQUE(card_id, alias)
);

-- ============================================================================
-- Cross-references: "See [Term]" lines between cards (How-to-Use: primary/secondary/third-level)
-- Cards often list multiple "See Term" lines; we store one row per term
-- associated with the source card. target_card_id is set when the relationship
-- is resolved (after import and data cleanup); until then it is NULL.
-- ============================================================================
CREATE TABLE IF NOT EXISTS cross_references (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    source_card_id  TEXT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    target_card_id  TEXT REFERENCES cards(id) ON DELETE SET NULL,  -- NULL until resolved
    display_text    TEXT NOT NULL,          -- Term text e.g. "Architecture" (for matching)
    line_content    TEXT,                   -- Full line as on card e.g. "See Architecture (1)"
    date_annotation TEXT,                   -- Optional dates e.g. "26 Sep'68; 2 Jul'62"
    reference_levels TEXT,                  -- Optional markers e.g. "(1)", "(2)", "(1) (2)"
    abstracted_elsewhere INTEGER,           -- 1 if asterisk present (How-to-Use: ref already abstracted among subject captions); NULL/0 otherwise
    sort_order      INTEGER NOT NULL,       -- Order of appearance within source card
    UNIQUE(source_card_id, target_card_id)  -- One resolved link per (source, target); multiple NULL targets allowed
);
-- Not in production: destroy and rebuild DB to apply schema changes.

-- ============================================================================
-- Bibliographic citations embedded in definition cards
-- ============================================================================
CREATE TABLE IF NOT EXISTS citations (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    card_id         TEXT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    citation_text   TEXT NOT NULL,          -- Full citation string
    source_type     TEXT,                   -- 'letter', 'book', 'tape', 'interview', 'manuscript', 'synergetics', 'other'
    source_title    TEXT,                   -- Extracted document name if parseable
    date            TEXT,                   -- Extracted date if parseable
    page            TEXT,                   -- Page reference if any
    location        TEXT,                   -- Geographical location for unpublished citations (How-to-Use)
    sort_order      INTEGER NOT NULL DEFAULT 0
);

-- ============================================================================
-- Synergetics section number index (from TEXT CITATIONS cards)
-- ============================================================================
CREATE TABLE IF NOT EXISTS section_refs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    card_id         TEXT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    term            TEXT NOT NULL,          -- Term being referenced e.g. "Absolute Zero"
    section_number  TEXT NOT NULL,          -- Synergetics section e.g. "205.02"
    sort_order      INTEGER NOT NULL DEFAULT 0
);

-- ============================================================================
-- Full-text search virtual table
-- ============================================================================
CREATE VIRTUAL TABLE IF NOT EXISTS cards_fts USING fts5(
    id,
    title,
    content_text,
    definition_text,
    content='cards',
    content_rowid='rowid'
);

-- Triggers to keep FTS in sync with cards table
CREATE TRIGGER IF NOT EXISTS cards_ai AFTER INSERT ON cards BEGIN
    INSERT INTO cards_fts(rowid, id, title, content_text, definition_text)
    VALUES (new.rowid, new.id, new.title, new.content_text, new.definition_text);
END;

CREATE TRIGGER IF NOT EXISTS cards_ad AFTER DELETE ON cards BEGIN
    INSERT INTO cards_fts(cards_fts, rowid, id, title, content_text, definition_text)
    VALUES ('delete', old.rowid, old.id, old.title, old.content_text, old.definition_text);
END;

CREATE TRIGGER IF NOT EXISTS cards_au AFTER UPDATE ON cards BEGIN
    INSERT INTO cards_fts(cards_fts, rowid, id, title, content_text, definition_text)
    VALUES ('delete', old.rowid, old.id, old.title, old.content_text, old.definition_text);
    INSERT INTO cards_fts(rowid, id, title, content_text, definition_text)
    VALUES (new.rowid, new.id, new.title, new.content_text, new.definition_text);
END;

-- ============================================================================
-- Indexes for common query patterns
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_cards_letter_group  ON cards(letter_group);
CREATE INDEX IF NOT EXISTS idx_cards_card_type     ON cards(card_type);
CREATE INDEX IF NOT EXISTS idx_cards_reviewed_at   ON cards(reviewed_at) WHERE reviewed_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_cards_sort_order    ON cards(sort_order);
CREATE INDEX IF NOT EXISTS idx_cards_card_number   ON cards(card_number);
CREATE INDEX IF NOT EXISTS idx_cross_references_source ON cross_references(source_card_id);
CREATE INDEX IF NOT EXISTS idx_cross_references_target ON cross_references(target_card_id);
CREATE INDEX IF NOT EXISTS idx_citations_card      ON citations(card_id);
CREATE INDEX IF NOT EXISTS idx_section_refs_card   ON section_refs(card_id);
CREATE INDEX IF NOT EXISTS idx_section_refs_section ON section_refs(section_number);
CREATE INDEX IF NOT EXISTS idx_card_aliases_card   ON card_aliases(card_id);
CREATE INDEX IF NOT EXISTS idx_card_aliases_alias  ON card_aliases(alias);
CREATE INDEX IF NOT EXISTS idx_cards_main_file_indicator ON cards(main_file_indicator_id);
CREATE INDEX IF NOT EXISTS idx_main_file_indicators_volume ON main_file_indicators(volume);
