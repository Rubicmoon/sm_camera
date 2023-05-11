// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'image_camera_controller_cubit.dart';

// ignore: must_be_immutable
class ImageCameraControllerState extends Equatable {
  final CameraController? controller;
  XFile? imageFile;
  final bool reTakeImage;
  final bool isFlashOn;
  final bool isTakingPicture;
  ImageCameraControllerState({
    this.controller,
    this.imageFile,
    this.isFlashOn = false,
    this.reTakeImage = false,
    this.isTakingPicture = false,
  });

  @override
  List<Object> get props => [
        if (controller != null) {controller},
        if (imageFile != null) {imageFile},
        isFlashOn,
        reTakeImage,
        isTakingPicture,
      ];

  ImageCameraControllerState copyWith({
    CameraController? controller,
    XFile? imageFile,
    bool? isFlashOn,
    bool? reTakeImage,
    bool? isTakingPicture,
  }) {
    return ImageCameraControllerState(
      controller: controller ?? this.controller,
      imageFile: imageFile ?? this.imageFile,
      isFlashOn: isFlashOn ?? false,
      reTakeImage: reTakeImage ?? false,
      isTakingPicture: isTakingPicture ?? false,
    );
  }
}
