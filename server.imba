import app from './api'

imba.serve app.listen(process.env.PORT or 3001)