import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoAttachmentWidget extends StatefulWidget {
  final Function(String) onPhotoSelected;

  const PhotoAttachmentWidget({
    Key? key,
    required this.onPhotoSelected,
  }) : super(key: key);

  @override
  State<PhotoAttachmentWidget> createState() => _PhotoAttachmentWidgetState();
}

class _PhotoAttachmentWidgetState extends State<PhotoAttachmentWidget> {
  List<String> _attachedPhotos = [];

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Ajouter une photo',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text('Prendre une photo'),
              subtitle: Text('Utilisez l\'appareil photo'),
              onTap: () {
                Navigator.pop(context);
                _simulatePhotoCapture();
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
              ),
              title: Text('Choisir depuis la galerie'),
              subtitle: Text('Sélectionnez une photo existante'),
              onTap: () {
                Navigator.pop(context);
                _simulateGallerySelection();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _simulatePhotoCapture() {
    // Simulate camera capture
    final mockPhotoPath =
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    setState(() {
      _attachedPhotos.add(mockPhotoPath);
    });
    widget.onPhotoSelected(mockPhotoPath);
  }

  void _simulateGallerySelection() {
    // Simulate gallery selection
    final mockPhotos = [
      'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1640774/pexels-photo-1640774.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ];
    final selectedPhoto =
        mockPhotos[DateTime.now().millisecond % mockPhotos.length];
    setState(() {
      _attachedPhotos.add(selectedPhoto);
    });
    widget.onPhotoSelected(selectedPhoto);
  }

  void _removePhoto(int index) {
    setState(() {
      _attachedPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Add photo button
          GestureDetector(
            onTap: _showPhotoOptions,
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'add_a_photo',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'Ajouter une photo',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          // Attached photos preview
          if (_attachedPhotos.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              height: 20.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachedPhotos.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: _attachedPhotos[index],
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 1.w,
                          right: 1.w,
                          child: GestureDetector(
                            onTap: () => _removePhoto(index),
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          // Photo count indicator
          if (_attachedPhotos.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              '${_attachedPhotos.length} photo${_attachedPhotos.length > 1 ? 's' : ''} ajoutée${_attachedPhotos.length > 1 ? 's' : ''}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getSuccessColor(true),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
