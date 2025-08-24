import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';

enum AvatarState { view, edit }

class Avatar extends StatefulWidget {
  final String? initialImagePath;
  final Function(String?)? onImageChanged;
  final AvatarState state;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final Color editButtonColor;
  final IconData defaultIcon;
  final IconData loadingIcon;

  const Avatar({
    super.key,
    this.initialImagePath,
    this.onImageChanged,
    this.state = AvatarState.edit,
    this.size = 96,
    this.backgroundColor = const Color(0xFFAE9DA0),
    this.iconColor = const Color(0xFF6D4C5A),
    this.editButtonColor = const Color(0xFFFF69B4),
    this.defaultIcon = Icons.person,
    this.loadingIcon = Icons.cloud_upload_outlined,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String? _imagePath;
  Uint8List? _webImageBytes;
  bool _isLoading = false;

  double get _radius => widget.size / 2;
  double get _iconSize => widget.size * 0.5;
  double get _editButtonSize => widget.size * 0.29;
  double get _editIconSize => _editButtonSize * 0.57;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImagePath;
  }

  @override
  void didUpdateWidget(Avatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImagePath != widget.initialImagePath) {
      setState(() {
        _imagePath = widget.initialImagePath;
        _webImageBytes = null;
      });
    }
  }

  Future<void> _pickImage() async {
    if (widget.state != AvatarState.edit) return;

    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      // log(result.toString());

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // log("File: ${file.toString()}");

        setState(() {
          _imagePath = file.path;
          _webImageBytes = file.bytes;
        });

        widget.onImageChanged?.call(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดระหว่างเลือกรูปภาพ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: ShapeDecoration(
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
      child: child,
    );
  }

  Widget _buildProfileImage() {
    if (_isLoading) {
      return _buildContainer(
        child: Icon(
          widget.loadingIcon,
          size: _iconSize,
          color: widget.iconColor,
        ),
      );
    }

    if (_webImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Image.memory(
          _webImageBytes!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_imagePath != null && _imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Image.file(
          File(_imagePath!),
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return _buildContainer(
      child: Icon(widget.defaultIcon, size: _iconSize, color: widget.iconColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildProfileImage(),

            if (widget.state == AvatarState.edit)
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: _editButtonSize,
                    height: _editButtonSize,
                    decoration: ShapeDecoration(
                      color: widget.editButtonColor,
                      shape: const CircleBorder(),
                      shadows: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      size: _editIconSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
