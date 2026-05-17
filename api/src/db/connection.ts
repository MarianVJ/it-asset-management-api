import sql from 'mssql';

const config: sql.config = {
  server:   process.env.DB_SERVER   || 'localhost',
  port:     process.env.DB_PORT     ? parseInt(process.env.DB_PORT) : undefined,
  database: process.env.DB_NAME     || '',
  user:     process.env.DB_USER     || '',
  password: process.env.DB_PASSWORD || '',
  options: {
    trustServerCertificate: true,
    enableArithAbort: true,
  },
};

let pool: sql.ConnectionPool | null = null;

export async function getPool(): Promise<sql.ConnectionPool> {
  if (!pool) {
    pool = await sql.connect(config);
  }
  return pool;
}

export { sql };
