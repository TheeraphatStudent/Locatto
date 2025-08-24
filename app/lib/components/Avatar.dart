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

  const Avatar({
    super.key,
    this.initialImagePath,
    this.onImageChanged,
    this.state = AvatarState.edit,
    this.size = 96,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  String? _imagePath;
  Uint8List? _webImageBytes;
  bool _isLoading = false;

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
        withData: true, // Web support
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        
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

  Widget _buildProfileImage() {
    final radius = widget.size / 2;

    if (_isLoading) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: ShapeDecoration(
          color: const Color(0xFFAE9DA0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_webImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
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
        borderRadius: BorderRadius.circular(radius),
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
    final radius = widget.size / 2;
    final iconSize = widget.size * 0.5;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: ShapeDecoration(
        color: const Color(0xFFAE9DA0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Icon(
        Icons.person,
        size: iconSize,
        color: const Color(0xFF6D4C5A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
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
                  width: 28,
                  height: 28,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFF69B4),
                    shape: CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}