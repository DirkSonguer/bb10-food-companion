// Some code based on https://github.com/blackberry/Cascades-Samples/blob/master/photobomber/src/photobomberapp.h

#ifndef CameraUtilities_HPP_
#define CameraUtilities_HPP_

#include <QtCore/QObject>
#include <QtCore/QMetaType>
#include <bb/cascades/multimedia/Camera>

#include <bb/cascades/Application>

using namespace bb;
using namespace bb::cascades;
using namespace bb::cascades::multimedia;

class CameraUtilities: public QObject {
Q_OBJECT

public:
	CameraUtilities();
	 ~CameraUtilities();

	/**
	 *  Function that lets you set up the aspect ratio of the camera, there
	 *  are limitations to the allowed values, the function will look for the
	 *  closest match.
	 *
	 *  @param camera the file path to the bombed image
	 *  @param aspect The ratio of w/h that should be used for the viewfinder
	 */
	Q_INVOKABLE
	void selectAspectRatio(bb::cascades::multimedia::Camera *camera,
			const float aspect);

	/**
	 * Helper function that opens an image in a QImage, rotates it according to the
	 * device orientation and EXIF data in the image on file and saves it back.
	 *
	 * @param imageFilePath the path to the picture file.
	 * @return A QImage containing the rotated picture.
	 */
	Q_INVOKABLE
	void correctImageOrientation(const QString imageFilePath);

private:
};

#endif /* CameraUtilities_HPP_ */
