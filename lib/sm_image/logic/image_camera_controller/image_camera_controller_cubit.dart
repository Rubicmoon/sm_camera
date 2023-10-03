import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sm_camera/utility/toast_message.dart';

part 'image_camera_controller_state.dart';

class ImageCameraControllerCubit extends Cubit<ImageCameraControllerState> {
  ImageCameraControllerCubit() : super(const ImageCameraControllerState());

  CameraController? _cameraController;
  // double _minAvailableExposureOffset = 0.0;
  // double _maxAvailableExposureOffset = 0.0;
  // double _minAvailableZoom = 1.0;
  // double _maxAvailableZoom = 1.0;
  // double _currentExposureOffset = 0.0;
  // double _currentScale = 1.0;
  // double _baseScale = 1.0;

  //default value, when the available cameras loaded, then exact camera count will assign
  int selectedCameraNumber = 0;
  List<CameraDescription> cameras = [];

  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
    return;
  }

  Future<void> initCameraModule({CameraDescription? cameraDescription}) async {
    if (cameraDescription == null) {
      cameras = await availableCameras();
    }

    if (cameraDescription == null && cameras.isEmpty) {
      ToastMessage.errorToast("No Camera found");
      return;
    }

    //take the 1st camera from the list as primary camera
    selectedCameraNumber = 0;
    final primaryCamera = cameras[selectedCameraNumber];

    final CameraController newCameraController = CameraController(
      cameraDescription ?? primaryCamera,
      // kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    //assign the newly created camera controller
    _cameraController = newCameraController;

    try {
      await Permission.camera.request();
      if (await Permission.camera.isGranted) {
        await _cameraController!.initialize();
        await Future.wait(<Future<Object?>>[
          // The exposure mode is currently not supported on the web.
          ...!kIsWeb
              ? <Future<Object?>>[
                  _cameraController!.getMinExposureOffset(),
                  // .then(
                  //     (double value) => _minAvailableExposureOffset = value),
                  _cameraController!.getMaxExposureOffset(),
                  // .then(
                  //     (double value) => _maxAvailableExposureOffset = value)
                ]
              : <Future<Object?>>[],
          _cameraController!.getMaxZoomLevel(),
          // .then((double value) => _maxAvailableZoom = value),
          _cameraController!.getMinZoomLevel(),
          // .then((double value) => _minAvailableZoom = value),
        ]);
        emit(state.copyWith(controller: _cameraController));
      } else if (await Permission.camera.isPermanentlyDenied) {
        emit(state.copyWith(cameraPermanentlyDenied: true));
      } else if (await Permission.camera.isDenied) {
        emit(state.copyWith(cameraDenied: true));
      }
    } on CameraException catch (e) {
      String error = "";
      switch (e.code) {
        case 'CameraAccessDenied':
          error = 'You have denied camera access.';
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          error = 'Please go to Settings app to enable camera access.';
          break;
        case 'CameraAccessRestricted':
          // iOS only
          error = 'Camera access is restricted.';
          break;
        case 'AudioAccessDenied':
          error = 'You have denied audio access.';
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          error = 'Please go to Settings app to enable audio access.';
          break;
        case 'AudioAccessRestricted':
          // iOS only
          error = 'Audio access is restricted.';
          break;
        default:
          error = e.toString();
          break;
      }
      ToastMessage.errorToast(error);

      if (isClosed) {
        return;
      }
      emit(state.copyWith(cameraFailed: true));
    } catch (error) {
      ToastMessage.errorToast(error.toString());

      if (isClosed) {
        return;
      }
      emit(state.copyWith(cameraFailed: true));
    }
  }

  Future<void> changeCamera() async {
    if (cameras.isEmpty || cameras.length == 1) {
      ToastMessage.errorToast("No available camera to switch");
      return;
    }
    if (_cameraController != null) {
      //0 is back camera, 1 is front camera
      selectedCameraNumber = selectedCameraNumber == 0 ? 1 : 0;
      await _cameraController!.setDescription(cameras[selectedCameraNumber]);
      emit(state.copyWith(controller: _cameraController));
      return;
    } else {
      return await initCameraModule(cameraDescription: cameras[0]);
    }
  }

  Future<void> takeImage() async {
    if (_cameraController != null) {
      try {
        emit(state.copyWith(isTakingPicture: true));
        final XFile file = await _cameraController!.takePicture();
        emit(state.copyWith(imageFile: file));
        return;
      } on CameraException catch (e) {
        ToastMessage.errorToast(e.toString());
        return;
      }
    } else {
      ToastMessage.errorToast("Unable to take image");
    }
  }

  Future<void> reTakeImage() async {
    if (_cameraController != null) {
      emit(state.copyWith(reTakeImage: true));
    } else {
      ToastMessage.errorToast("Unable to take image");
    }
  }

  Future<void> toggleFlash() async {
    if (_cameraController != null) {
      await _cameraController!.setFlashMode(
        state.isFlashOn ? FlashMode.off : FlashMode.torch,
      );
      emit(state.copyWith(isFlashOn: !state.isFlashOn));
    } else {
      ToastMessage.errorToast("Unable to take image");
    }
  }
}
