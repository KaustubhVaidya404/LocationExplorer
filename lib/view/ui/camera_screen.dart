import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:locationexplorer/view/widgets/photo_preview.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.camera});

  final List<CameraDescription>? camera;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isRealCameraSelected = true;

  navigator(XFile picture) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ImagePreview(image: picture)));
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.camera![0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      navigator(picture);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRealCameraSelected
                          ? Icons.switch_camera
                          : Icons.switch_camera_outlined,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRealCameraSelected = !_isRealCameraSelected);
                    initCamera(widget.camera![_isRealCameraSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 60,
                  ),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
