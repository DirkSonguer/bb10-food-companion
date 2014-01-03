/*
 * Copyright (c) 2011-2013 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "foodcompanion.hpp"
#include "camerautilities.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/multimedia/CameraSettings>
#include <bb/cascades/SceneCover>
#include <bb/device/DisplayInfo>

using namespace bb::device;
using namespace bb::cascades;
using namespace bb::cascades::multimedia;

FoodCompanion::FoodCompanion(bb::cascades::Application *app) :
		QObject(app) {

	// register camera utilities
	qmlRegisterType<CameraUtilities>("CameraUtilities", 1, 0, "CameraUtilities");

	// register timer functionalities
	qmlRegisterType<QTimer>("QtTimer", 1, 0, "Timer");

	// register SceneCover functionalities
	qmlRegisterType<SceneCover>("bb.cascades", 1, 0, "SceneCover");

	// Since it is not possible to create an instance of the AbstractCover
	// it is registered as an uncreatable type (necessary for accessing
	// Application.cover).
	qmlRegisterUncreatableType<AbstractCover>("bb.cascades", 1, 0,
			"AbstractCover", "An AbstractCover cannot be created.");

	// prepare the localization
	m_pTranslator = new QTranslator(this);
	m_pLocaleHandler = new LocaleHandler(this);

	bool res = QObject::connect(m_pLocaleHandler,
			SIGNAL(systemLanguageChanged()), this,
			SLOT(onSystemLanguageChanged()));
	// This is only available in Debug builds
	Q_ASSERT(res);
	// Since the variable is not used in the app, this is added to avoid a
	// compiler warning
	Q_UNUSED(res);

	// initial load
	onSystemLanguageChanged();

	// Create scene document from main.qml asset, the parent is set
	// to ensure the document gets destroyed properly at shut down.
	QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Retrieve the path to the app's working directory
    QString workingDir = QDir::currentPath();

    // Build the path, add it as a context property, and expose
    // it to QML
    QDeclarativePropertyMap* dirPaths = new QDeclarativePropertyMap;
    dirPaths->insert("currentPath", QVariant(QString(
            "file://" + workingDir)));
    dirPaths->insert("assetPath", QVariant(QString(
            "file://" + workingDir + "/app/native/assets/")));
    qml->setContextProperty("dirPaths", dirPaths);

	DisplayInfo display;
	int width = display.pixelSize().width();
	int height = display.pixelSize().height();

	QDeclarativePropertyMap* displayProperties = new QDeclarativePropertyMap;
	displayProperties->insert("width", QVariant(width));
	displayProperties->insert("height", QVariant(height));

	qml->setContextProperty("DisplayInfo", displayProperties);

	// Create root object for the UI
	AbstractPane *root = qml->createRootObject<AbstractPane>();

	// Set created root object as the application scene
	app->setScene(root);
}

void FoodCompanion::onSystemLanguageChanged() {
	QCoreApplication::instance()->removeTranslator(m_pTranslator);
	// Initiate, load and install the application translation files.
	QString locale_string = QLocale().name();
	QString file_name = QString("FoodCompanionBB10_%1").arg(locale_string);
	if (m_pTranslator->load(file_name, "app/native/qm")) {
		QCoreApplication::instance()->installTranslator(m_pTranslator);
	}
}
