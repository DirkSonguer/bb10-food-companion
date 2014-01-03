APP_NAME = FoodCompanionBB10

CONFIG += qt warn_on cascades10

QT += network

LIBS += -lbbdevice -lbbplatform -lcamapi -lscreen
LIBS += -lbbcascadesmultimedia
LIBS += -lbbsystem
LIBS += -lexif

include(config.pri)
