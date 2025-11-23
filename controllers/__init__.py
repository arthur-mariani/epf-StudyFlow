from bottle import Bottle
from controllers.user_controller import user_routes
from controllers.signin_controller import signin_routes
from controllers.login_controller import login_routes

def init_controllers(app: Bottle):
    app.merge(user_routes)
    app.merge(signin_routes)
    app.merge(login_routes)
