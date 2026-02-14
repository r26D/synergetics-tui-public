import Database from 'better-sqlite3';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DB_PATH = path.join(__dirname, '../data/synergetics_dictionary.db');

let db = null;

export function openDatabase() {
  if (!db) {
    db = new Database(DB_PATH, { readonly: false });
  }
  return db;
}

export function closeDatabase() {
  if (db) {
    db.close();
    db = null;
  }
}

export function countCards() {
  const db = openDatabase();
  const result = db.prepare('SELECT COUNT(*) as count FROM cards').get();
  return result.count;
}

export function listCards({ limit = 20, offset = 0, search = null }) {
  const db = openDatabase();

  let query = 'SELECT id, card_number, title, reference_level, reference_level_label, needs_review, review_notes FROM cards';
  let params = [];

  if (search) {
    query += ' WHERE title LIKE ? OR content_text LIKE ?';
    params.push(`%${search}%`, `%${search}%`);
  }

  query += ' ORDER BY card_number LIMIT ? OFFSET ?';
  params.push(limit, offset);

  return db.prepare(query).all(...params);
}

export function getCard(id) {
  const db = openDatabase();
  return db.prepare('SELECT * FROM cards WHERE id = ?').get(id);
}

export function updateCard(id, fields) {
  const db = openDatabase();
  
  const updates = [];
  const values = [];
  
  for (const [key, value] of Object.entries(fields)) {
    updates.push(`${key} = ?`);
    values.push(value);
  }
  
  values.push(id);
  
  const query = `UPDATE cards SET ${updates.join(', ')} WHERE id = ?`;
  const result = db.prepare(query).run(...values);
  
  return result.changes > 0;
}

export function searchCards(query) {
  const db = openDatabase();
  return db.prepare(`
    SELECT id, card_number, title, reference_level, reference_level_label, needs_review, review_notes
    FROM cards
    WHERE title LIKE ? OR content_text LIKE ?
    ORDER BY card_number
    LIMIT 50
  `).all(`%${query}%`, `%${query}%`);
}

