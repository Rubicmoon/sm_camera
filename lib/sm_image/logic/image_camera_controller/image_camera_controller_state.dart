part of 'image_camera_controller_cubit.dart';

// ignore: must_be_immutable
class ImageCameraControllerState extends Equatable {
  final CameraController? controller;
  final XFile? imageFile;
  final bool reTakeImage;
  final bool isFlashOn;
  final bool cameraFailed;
  final bool cameraDenied;
  final bool isTakingPicture;
  final bool cameraPermanentlyDenied;
  const ImageCameraControllerState({
    this.controller,
    this.imageFile,
    this.isFlashOn = false,
    this.reTakeImage = false,
    this.isTakingPicture = false,
    this.cameraDenied = false,
    this.cameraFailed = false,
    this.cameraPermanentlyDenied = false,
  });

  @override
  List<Object?> get props => [
        controller,
        imageFile,
        isFlashOn,
        reTakeImage,
        isTakingPicture,
        cameraDenied,
        cameraPermanentlyDenied,
      ];

  ImageCameraControllerState copyWith({
    CameraController? controller,
    XFile? imageFile,
    bool? isFlashOn,
    bool? reTakeImage,
    bool? cameraDenied,
    bool? cameraFailed,
    bool? isTakingPicture,
    bool? cameraPermanentlyDenied,
  }) {
    return ImageCameraControllerState(
      controller: controller ?? this.controller,
      imageFile: imageFile,
      isFlashOn: isFlashOn ?? false,
      reTakeImage: reTakeImage ?? false,
      isTakingPicture: isTakingPicture ?? false,
      cameraFailed: cameraFailed ?? false,
      cameraDenied: cameraDenied ?? false,
      cameraPermanentlyDenied: cameraPermanentlyDenied ?? false,
    );
  }
}
