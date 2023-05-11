// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'image_camera_controller_cubit.dart';

class ImageCameraControllerState extends Equatable {
  final CameraController? controller;
  const ImageCameraControllerState({
    this.controller,
  });

  @override
  List<Object> get props => [
        if (controller != null) {controller}
      ];

  ImageCameraControllerState copyWith({
    CameraController? controller,
  }) {
    return ImageCameraControllerState(controller: controller);
  }
}
