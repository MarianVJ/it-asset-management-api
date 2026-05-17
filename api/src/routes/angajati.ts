import Router from 'koa-router';
import * as angajati from '../controllers/angajati';

const router = new Router({ prefix: '/angajati' });

router.get('/',    angajati.getAll);
router.get('/:id', angajati.getById);
router.post('/',   angajati.create);
router.put('/:id', angajati.update);
router.delete('/:id', angajati.remove);

export default router;
