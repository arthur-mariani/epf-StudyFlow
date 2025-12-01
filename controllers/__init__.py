from bottle import Bottle
from controllers.signin_controller import signin_routes
from controllers.login_controller import login_routes
from controllers.home_controller import home_routes
from .settings_controller import settings_routes 
from controllers.statistics_controller import statistics_routes

def init_controllers(app: Bottle):
    app.merge(signin_routes)
    app.merge(login_routes)
    app.merge(home_routes)
    app.merge(settings_routes)
    app.merge(statistics_routes)