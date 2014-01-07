// Some code based on https://github.com/blackberry/Cascades-Samples/blob/master/photobomber/src/photobomberapp.cpp

#include "camerautilities.hpp"

#include <QtGui/QImage>
#include <QtGui/QImageReader>

#include <bb/cascades/Page>
#include <bb/cascades/QmlDocument>

#include <bb/cascades/multimedia/CameraSettings>

#include <bb/system/InvokeRequest>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeTargetReply>

#include <libexif/exif-data.h>

using namespace bb;
using namespace bb::cascades;
using namespace bb::cascades::multimedia;
using namespace bb::system;

// Macro for getting the difference in x and y direction
#define DELTA(x, y) (x>y?(x-y):(y-x))

CameraUtilities::CameraUtilities() {

}

CameraUtilities::~CameraUtilities()
{
}

void CameraUtilities::selectAspectRatio(bb::cascades::multimedia::Camera *camera, const float aspect)
{
    CameraSettings camsettings;
    camera->getSettings(&camsettings);

    // Get a list of supported resolutions.
    QVariantList reslist = camera->supportedCaptureResolutions(CameraMode::Photo);

    // Find the closest match to the aspect parameter
    for (int i = 0; i < reslist.count(); i++) {
        QSize res = reslist[i].toSize();
        qDebug() << "supported resolution: " << res.width() << "x" << res.height();

        // Check for w:h or h:w within 5px margin of error...
        if ((DELTA(res.width() * aspect, res.height()) < 5)
                || (DELTA(res.width(), res.height() * aspect) < 5)) {
            qDebug() << "picking resolution: " << res.width() << "x" << res.height();
            camsettings.setCaptureResolution(res);
            break;
        }
    }

    // Update the camera setting
    camera->applySettings(&camsettings);
}

void CameraUtilities::correctImageOrientation(const QString imageFilePath)
{
    //Load the image using QImage.
    QImage image = QImage(imageFilePath);

    if (image.width() < 1) {
        qDebug() << "Image could not be loaded: " << imageFilePath;
    }

    ExifData *exifData = 0;
    ExifEntry *exifEntry = 0;
    int exifOrientation = 1;

    // Since the image will loose its exif data when its opened in a QImage
    // it has to be manually rotated according to the exif orientation.
    exifData = exif_data_new_from_file(imageFilePath.toLatin1().data());

    // Locate the orientation exif information.
    if (exifData != NULL) {
        for (int i = 0; i < EXIF_IFD_COUNT; i++) {
            exifEntry = exif_content_get_entry(exifData->ifd[i], EXIF_TAG_ORIENTATION);

            // If the entry corresponds to the orientation it will be a non zero pointer.
            if (exifEntry) {
                exifOrientation = exif_get_short(exifEntry->data, exif_data_get_byte_order(exifData));
                break;
            }
        }
    }

    // A transform will be used to rotate the image according to device and exif orientation.
    QTransform transform;

    qDebug() << "Exif data:" << exifOrientation;


    // It's a bit tricky to get the correct orientation of the image. A combination of
    // the way the the device is oriented and what the actual exif data says has to be used
    // in order to rotate it in the correct way.
    switch(exifOrientation) {
        case 1:
            // 0 degree rotation
            break;
        case 3:
            // 180 degree rotation
            transform.rotate(180);
            break;
        case 6:
            // 90 degree rotation
            transform.rotate(90);
            break;
        case 8:
            // 270 degree rotation
            transform.rotate(270);
            break;
        default:
            // Other orientations are mirrored orientations, do nothing.
            break;
    }

    // Perform the rotation of the image before its saved.
    image = image.transformed(transform);

    image.save(imageFilePath, "JPG");
}
