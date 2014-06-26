# Config.pri file version 2.0. Auto-generated by IDE. Any changes made by user will be lost!
BASEDIR = $$quote($$_PRO_FILE_PWD_)

device {
    CONFIG(debug, debug|release) {
        profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        } else {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }

    }

    CONFIG(release, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

simulator {
    CONFIG(debug, debug|release) {
        !profile {
            CONFIG += \
                config_pri_assets \
                config_pri_source_group1
        }
    }
}

config_pri_assets {
    OTHER_FILES += \
        $$quote($$BASEDIR/assets/classes/configurationhandler.js) \
        $$quote($$BASEDIR/assets/classes/entrydatabase.js) \
        $$quote($$BASEDIR/assets/classes/itemdatabase.js) \
        $$quote($$BASEDIR/assets/components/CustomButton.qml) \
        $$quote($$BASEDIR/assets/components/CustomCamera.qml) \
        $$quote($$BASEDIR/assets/components/CustomHeader.qml) \
        $$quote($$BASEDIR/assets/components/CustomSlider.qml) \
        $$quote($$BASEDIR/assets/components/FoodEntryDescription.qml) \
        $$quote($$BASEDIR/assets/components/FoodGalleryItem.qml) \
        $$quote($$BASEDIR/assets/components/FoodGalleryList.qml) \
        $$quote($$BASEDIR/assets/components/FoodInput.qml) \
        $$quote($$BASEDIR/assets/components/FoodItem.qml) \
        $$quote($$BASEDIR/assets/components/FoodItemList.qml) \
        $$quote($$BASEDIR/assets/components/ImageWithBorder.qml) \
        $$quote($$BASEDIR/assets/components/InfoMessage.qml) \
        $$quote($$BASEDIR/assets/database/food_db.json) \
        $$quote($$BASEDIR/assets/global/copytext.js) \
        $$quote($$BASEDIR/assets/global/globals.js) \
        $$quote($$BASEDIR/assets/images/emoticons/01_angry.png) \
        $$quote($$BASEDIR/assets/images/emoticons/02_crying.png) \
        $$quote($$BASEDIR/assets/images/emoticons/03_sad.png) \
        $$quote($$BASEDIR/assets/images/emoticons/04_surprised.png) \
        $$quote($$BASEDIR/assets/images/emoticons/05_happy.png) \
        $$quote($$BASEDIR/assets/images/emoticons/06_wink.png) \
        $$quote($$BASEDIR/assets/images/emoticons/07_lol.png) \
        $$quote($$BASEDIR/assets/images/header_background.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_about.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_add.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_addentry.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_appicon.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_bbworld.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_bookmarked.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_bookmarked_dark.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_camera.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_close.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_delete.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_description.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_flash.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_focussed.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_focussing.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_gallery.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_notavailable.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_notbookmarked.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_notbookmarked_dark.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_search.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_search_dimmed.png) \
        $$quote($$BASEDIR/assets/images/icons/icon_statistics.png) \
        $$quote($$BASEDIR/assets/images/page_background.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/splashscreen_1280x720.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/splashscreen_1280x768.png) \
        $$quote($$BASEDIR/assets/images/splashscreens/splashscreen_720x720.png) \
        $$quote($$BASEDIR/assets/main.qml) \
        $$quote($$BASEDIR/assets/pages/FoodEntryDetail.qml) \
        $$quote($$BASEDIR/assets/pages/FoodGallery.qml) \
        $$quote($$BASEDIR/assets/pages/NewFoodEntry.qml) \
        $$quote($$BASEDIR/assets/pages/NewFoodItem.qml) \
        $$quote($$BASEDIR/assets/pages/SelectFoodItem.qml) \
        $$quote($$BASEDIR/assets/sheets/About.qml) \
        $$quote($$BASEDIR/assets/sheets/CaptureImage.qml) \
        $$quote($$BASEDIR/assets/sheets/FirstStartup.qml) \
        $$quote($$BASEDIR/assets/structures/foodentry.js) \
        $$quote($$BASEDIR/assets/structures/fooditem.js)
}

config_pri_source_group1 {
    SOURCES += \
        $$quote($$BASEDIR/src/camerautilities.cpp) \
        $$quote($$BASEDIR/src/foodcompanion.cpp) \
        $$quote($$BASEDIR/src/main.cpp)

    HEADERS += \
        $$quote($$BASEDIR/src/camerautilities.hpp) \
        $$quote($$BASEDIR/src/foodcompanion.hpp)
}

INCLUDEPATH += $$quote($$BASEDIR/src)

CONFIG += precompile_header

PRECOMPILED_HEADER = $$quote($$BASEDIR/precompiled.h)

lupdate_inclusion {
    SOURCES += \
        $$quote($$BASEDIR/../src/*.c) \
        $$quote($$BASEDIR/../src/*.c++) \
        $$quote($$BASEDIR/../src/*.cc) \
        $$quote($$BASEDIR/../src/*.cpp) \
        $$quote($$BASEDIR/../src/*.cxx) \
        $$quote($$BASEDIR/../assets/*.qml) \
        $$quote($$BASEDIR/../assets/*.js) \
        $$quote($$BASEDIR/../assets/*.qs) \
        $$quote($$BASEDIR/../assets/classes/*.qml) \
        $$quote($$BASEDIR/../assets/classes/*.js) \
        $$quote($$BASEDIR/../assets/classes/*.qs) \
        $$quote($$BASEDIR/../assets/components/*.qml) \
        $$quote($$BASEDIR/../assets/components/*.js) \
        $$quote($$BASEDIR/../assets/components/*.qs) \
        $$quote($$BASEDIR/../assets/covers/*.qml) \
        $$quote($$BASEDIR/../assets/covers/*.js) \
        $$quote($$BASEDIR/../assets/covers/*.qs) \
        $$quote($$BASEDIR/../assets/database/*.qml) \
        $$quote($$BASEDIR/../assets/database/*.js) \
        $$quote($$BASEDIR/../assets/database/*.qs) \
        $$quote($$BASEDIR/../assets/global/*.qml) \
        $$quote($$BASEDIR/../assets/global/*.js) \
        $$quote($$BASEDIR/../assets/global/*.qs) \
        $$quote($$BASEDIR/../assets/images/*.qml) \
        $$quote($$BASEDIR/../assets/images/*.js) \
        $$quote($$BASEDIR/../assets/images/*.qs) \
        $$quote($$BASEDIR/../assets/images/emoticons/*.qml) \
        $$quote($$BASEDIR/../assets/images/emoticons/*.js) \
        $$quote($$BASEDIR/../assets/images/emoticons/*.qs) \
        $$quote($$BASEDIR/../assets/images/icons/*.qml) \
        $$quote($$BASEDIR/../assets/images/icons/*.js) \
        $$quote($$BASEDIR/../assets/images/icons/*.qs) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.qml) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.js) \
        $$quote($$BASEDIR/../assets/images/splashscreens/*.qs) \
        $$quote($$BASEDIR/../assets/pages/*.qml) \
        $$quote($$BASEDIR/../assets/pages/*.js) \
        $$quote($$BASEDIR/../assets/pages/*.qs) \
        $$quote($$BASEDIR/../assets/sheets/*.qml) \
        $$quote($$BASEDIR/../assets/sheets/*.js) \
        $$quote($$BASEDIR/../assets/sheets/*.qs) \
        $$quote($$BASEDIR/../assets/structures/*.qml) \
        $$quote($$BASEDIR/../assets/structures/*.js) \
        $$quote($$BASEDIR/../assets/structures/*.qs)

    HEADERS += \
        $$quote($$BASEDIR/../src/*.h) \
        $$quote($$BASEDIR/../src/*.h++) \
        $$quote($$BASEDIR/../src/*.hh) \
        $$quote($$BASEDIR/../src/*.hpp) \
        $$quote($$BASEDIR/../src/*.hxx)
}

TRANSLATIONS = $$quote($${TARGET}.ts)
