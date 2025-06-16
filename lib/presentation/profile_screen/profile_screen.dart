import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/profile_setting_item_widget.dart';
import './widgets/storage_usage_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationsEnabled = true;
  bool isAutoDownloadEnabled = false;
  bool isDarkModeEnabled = true;
  String selectedLanguage = 'العربية';
  String selectedVideoQuality = 'HD 1080p';

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "أحمد محمد",
    "email": "ahmed.mohamed@example.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "joinDate": "يناير 2023",
    "downloadedSize": "2.4 GB"
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'الملف الشخصي',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.darkTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userData: userData,
                onEditPressed: () => _showEditProfileDialog(),
              ),

              SizedBox(height: 3.h),

              // Account Section
              ProfileSectionWidget(
                title: 'الحساب',
                children: [
                  ProfileSettingItemWidget(
                    icon: 'edit',
                    title: 'تعديل الملف الشخصي',
                    onTap: () => _showEditProfileDialog(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'lock',
                    title: 'تغيير كلمة المرور',
                    onTap: () => _showChangePasswordDialog(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'notifications',
                    title: 'إعدادات الإشعارات',
                    trailing: Switch(
                      value: isNotificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          isNotificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'privacy_tip',
                    title: 'إعدادات الخصوصية',
                    onTap: () => _showPrivacySettings(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // App Settings Section
              ProfileSectionWidget(
                title: 'إعدادات التطبيق',
                children: [
                  ProfileSettingItemWidget(
                    icon: 'language',
                    title: 'اللغة',
                    subtitle: selectedLanguage,
                    onTap: () => _showLanguageSelector(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'high_quality',
                    title: 'جودة الفيديو',
                    subtitle: selectedVideoQuality,
                    onTap: () => _showVideoQualitySelector(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'download',
                    title: 'إعدادات التحميل',
                    trailing: Switch(
                      value: isAutoDownloadEnabled,
                      onChanged: (value) {
                        setState(() {
                          isAutoDownloadEnabled = value;
                        });
                      },
                    ),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'data_usage',
                    title: 'التحكم في استخدام البيانات',
                    onTap: () => _showDataUsageSettings(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'dark_mode',
                    title: 'الوضع المظلم',
                    trailing: Switch(
                      value: isDarkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Storage Usage
              StorageUsageWidget(
                downloadedSize: userData["downloadedSize"] as String,
                onManageDownloads: () => _showManageDownloads(),
              ),

              SizedBox(height: 2.h),

              // Advanced Options Section
              ProfileSectionWidget(
                title: 'خيارات متقدمة',
                children: [
                  ProfileSettingItemWidget(
                    icon: 'clear_all',
                    title: 'مسح ذاكرة التخزين المؤقت',
                    onTap: () => _showClearCacheDialog(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'refresh',
                    title: 'إعادة تعيين التطبيق',
                    onTap: () => _showResetAppDialog(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'file_download',
                    title: 'تصدير البيانات',
                    onTap: () => _exportData(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'delete_forever',
                    title: 'حذف الحساب',
                    titleColor: AppTheme.errorDark,
                    onTap: () => _showDeleteAccountDialog(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // About Section
              ProfileSectionWidget(
                title: 'حول التطبيق',
                children: [
                  ProfileSettingItemWidget(
                    icon: 'info',
                    title: 'إصدار التطبيق',
                    subtitle: '1.0.0',
                  ),
                  ProfileSettingItemWidget(
                    icon: 'description',
                    title: 'شروط الخدمة',
                    onTap: () => _showTermsOfService(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'policy',
                    title: 'سياسة الخصوصية',
                    onTap: () => _showPrivacyPolicy(),
                  ),
                  ProfileSettingItemWidget(
                    icon: 'support',
                    title: 'الدعم الفني',
                    onTap: () => _contactSupport(),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Logout Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorDark,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'تسجيل الخروج',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل الملف الشخصي'),
        content: Text('سيتم فتح شاشة تعديل الملف الشخصي'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير كلمة المرور'),
        content: Text('سيتم فتح شاشة تغيير كلمة المرور'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إعدادات الخصوصية'),
        content: Text('سيتم فتح شاشة إعدادات الخصوصية'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختيار اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('العربية'),
              value: 'العربية',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('English'),
              value: 'English',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoQualitySelector() {
    final qualities = ['4K 2160p', 'HD 1080p', 'HD 720p', 'SD 480p', 'تلقائي'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('جودة الفيديو'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: qualities
              .map((quality) => RadioListTile<String>(
                    title: Text(quality),
                    value: quality,
                    groupValue: selectedVideoQuality,
                    onChanged: (value) {
                      setState(() {
                        selectedVideoQuality = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDataUsageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('التحكم في استخدام البيانات'),
        content: Text('سيتم فتح شاشة إعدادات استخدام البيانات'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showManageDownloads() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إدارة التحميلات'),
        content: Text('سيتم فتح شاشة إدارة التحميلات'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('مسح ذاكرة التخزين المؤقت'),
        content: Text('هل أنت متأكد من رغبتك في مسح ذاكرة التخزين المؤقت؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم مسح ذاكرة التخزين المؤقت')),
              );
            },
            child: Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _showResetAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إعادة تعيين التطبيق'),
        content: Text(
            'هل أنت متأكد من رغبتك في إعادة تعيين التطبيق؟ سيتم فقدان جميع الإعدادات والبيانات المحلية.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إعادة تعيين التطبيق')),
              );
            },
            child: Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('جاري تصدير البيانات...')),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الحساب'),
        content: Text(
            'تحذير: هذا الإجراء لا يمكن التراجع عنه. سيتم حذف جميع بياناتك نهائياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف الحساب')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorDark),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('شروط الخدمة'),
        content: Text('سيتم فتح شاشة شروط الخدمة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سياسة الخصوصية'),
        content: Text('سيتم فتح شاشة سياسة الخصوصية'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الدعم الفني'),
        content: Text(
            'للتواصل مع الدعم الفني:\nالبريد الإلكتروني: support@webmediaplayer.com\nالهاتف: +966-11-123-4567'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home-screen',
                (route) => false,
              );
            },
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
