import { Context } from 'koa';
import { getPool, sql } from '../db/connection';

export async function getAll(ctx: Context) {
  const pool = await getPool();
  const result = await pool.request()
    .query('SELECT * FROM angajati WHERE activ = 1 ORDER BY nume, prenume');
  ctx.body = result.recordset;
}

export async function getById(ctx: Context) {
  const id = Number((ctx as any).params.id);
  const pool = await getPool();
  const result = await pool.request()
    .input('id', sql.Int, id)
    .query('SELECT * FROM angajati WHERE id = @id');

  if (!result.recordset.length) {
    ctx.status = 404;
    ctx.body = { error: 'Angajat negasit' };
    return;
  }
  ctx.body = result.recordset[0];
}

export async function create(ctx: Context) {
  const { nume, prenume, email, departament } = (ctx.request as any).body;

  if (!nume || !prenume || !email) {
    ctx.status = 400;
    ctx.body = { error: 'Campuri obligatorii: nume, prenume, email' };
    return;
  }

  const pool = await getPool();
  const result = await pool.request()
    .input('nume',       sql.NVarChar(100), nume)
    .input('prenume',    sql.NVarChar(100), prenume)
    .input('email',      sql.NVarChar(150), email)
    .input('departament', sql.NVarChar(100), departament ?? null)
    .query(`
      INSERT INTO angajati (nume, prenume, email, departament)
      OUTPUT INSERTED.*
      VALUES (@nume, @prenume, @email, @departament)
    `);

  ctx.status = 201;
  ctx.body = result.recordset[0];
}

export async function update(ctx: Context) {
  const id = Number((ctx as any).params.id);
  const { nume, prenume, email, departament } = (ctx.request as any).body;

  if (!nume || !prenume || !email) {
    ctx.status = 400;
    ctx.body = { error: 'Campuri obligatorii: nume, prenume, email' };
    return;
  }

  const pool = await getPool();
  const result = await pool.request()
    .input('id',         sql.Int,           id)
    .input('nume',       sql.NVarChar(100), nume)
    .input('prenume',    sql.NVarChar(100), prenume)
    .input('email',      sql.NVarChar(150), email)
    .input('departament', sql.NVarChar(100), departament ?? null)
    .query(`
      UPDATE angajati
      SET nume = @nume, prenume = @prenume, email = @email,
          departament = @departament, updated_at = GETDATE()
      OUTPUT INSERTED.*
      WHERE id = @id AND activ = 1
    `);

  if (!result.recordset.length) {
    ctx.status = 404;
    ctx.body = { error: 'Angajat negasit' };
    return;
  }
  ctx.body = result.recordset[0];
}

export async function remove(ctx: Context) {
  const id = Number((ctx as any).params.id);
  const pool = await getPool();
  const result = await pool.request()
    .input('id', sql.Int, id)
    .query(`
      UPDATE angajati
      SET activ = 0, updated_at = GETDATE()
      OUTPUT INSERTED.id
      WHERE id = @id AND activ = 1
    `);

  if (!result.recordset.length) {
    ctx.status = 404;
    ctx.body = { error: 'Angajat negasit' };
    return;
  }
  ctx.body = { message: 'Angajat dezactivat' };
}
