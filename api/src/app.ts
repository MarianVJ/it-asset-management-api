import Koa from 'koa';
import bodyParser from 'koa-bodyparser';
import angajatiRouter from './routes/angajati';

const app = new Koa();

app.use(async (ctx, next) => {
  try {
    await next();
  } catch (err: any) {
    ctx.status = err.status || 500;
    ctx.body = { error: err.message || 'Internal Server Error' };
  }
});

app.use(bodyParser());

app.use(angajatiRouter.routes()).use(angajatiRouter.allowedMethods());

export default app;
