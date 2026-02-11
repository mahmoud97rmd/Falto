#!/data/data/com.termux/files/usr/bin/python3
# -*- coding: utf-8 -*-

"""
سكربت استخراج أكواد مشروع Flutter
إصدار: 1.0
تاريخ: 2024
"""

import os
import sys
import datetime
import pathlib
import mimetypes
from typing import List, Dict, Set

class FlutterCodeExtractor:
    def __init__(self, project_path: str = "."):
        """تهيئة مستخرج الأكواد"""
        self.project_path = os.path.abspath(project_path)
        self.project_name = os.path.basename(self.project_path)
        self.timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # إعداد ملف الإخراج
        self.output_file = f"flutter_codes_{self.timestamp}.txt"
        
        # تعريف الامتدادات المهمة لمشروع Flutter
        self.code_extensions = {
            '.dart': 'Dart',
            '.yaml': 'YAML',
            '.yml': 'YAML',
            '.json': 'JSON',
            '.xml': 'XML',
            '.html': 'HTML',
            '.css': 'CSS',
            '.md': 'Markdown',
            '.txt': 'Text',
            '.gradle': 'Gradle',
            '.java': 'Java',
            '.kt': 'Kotlin',
            '.swift': 'Swift',
            '.m': 'Objective-C',
            '.h': 'Header',
            '.cpp': 'C++',
            '.c': 'C',
            '.plist': 'Plist',
            '.sh': 'Shell',
            '.bash': 'Bash',
            '.py': 'Python',
            '.js': 'JavaScript',
            '.ts': 'TypeScript',
            '.jsx': 'React JS',
            '.tsx': 'React TS',
            '.sql': 'SQL',
            '.php': 'PHP',
            '.rb': 'Ruby',
            '.go': 'Go',
            '.rs': 'Rust',
            '.lua': 'Lua',
            '.ini': 'INI',
            '.conf': 'Config',
            '.cfg': 'Config',
            '.toml': 'TOML',
            '.properties': 'Properties',
        }
        
        # المجلدات التي يجب استبعادها
        self.exclude_dirs = {
            'build', '.dart_tool', '.git', '.github', '.vscode', '.idea',
            '__pycache__', 'node_modules', '.gradle', '.android', '.ios',
            'Pods', 'DerivedData', '.pub-cache', 'target', 'dist', 'out',
            'tmp', 'temp', 'logs', 'coverage', '.flutter-plugins',
            '.flutter-plugins-dependencies'
        }
        
        # الملفات التي يجب استبعادها
        self.exclude_files = {
            '*.apk', '*.ipa', '*.app', '*.jar', '*.class', '*.so', '*.o',
            '*.a', '*.pyc', '*.pyo', '*.pyd', '*.dll', '*.exe', '*.bin',
            '*.dat', '*.db', '*.sqlite', '*.jpg', '*.jpeg', '*.png',
            '*.gif', '*.bmp', '*.ico', '*.pdf', '*.doc', '*.docx',
            '*.xls', '*.xlsx', '*.ppt', '*.pptx', '*.zip', '*.tar',
            '*.gz', '*.rar', '*.7z', '*.mp3', '*.mp4', '*.avi', '*.mov',
            '*.wmv', '*.flv', '*.mkv', '.DS_Store', 'Thumbs.db',
            'flutter_trading_app.iml'
        }
        
        # إحصائيات
        self.stats = {
            'total_files': 0,
            'total_lines': 0,
            'total_size': 0,
            'files_by_type': {},
            'files_by_folder': {}
        }
        
        # ترتيب المجلدات حسب الأهمية
        self.priority_folders = [
            'lib',
            'src',
            'test',
            'integration_test',
            'android/app/src',
            'ios/Runner',
            'macos/Runner',
            'windows/runner',
            'scripts',
            'assets',
            'docs',
            'web',
            'linux',
        ]
    
    def should_exclude(self, path: str) -> bool:
        """فحص إذا كان المسار يجب استبعاده"""
        # استبعاد إذا كان مجلد مستبعد
        for part in path.split(os.sep):
            if part in self.exclude_dirs:
                return True
        
        # استبعاد الملفات بنمط معين
        filename = os.path.basename(path)
        for pattern in self.exclude_files:
            if pattern.startswith('*.'):
                ext = pattern[1:]
                if filename.endswith(ext):
                    return True
            elif filename == pattern:
                return True
        
        return False
    
    def get_file_type(self, filename: str) -> str:
        """الحصول على نوع الملف من الامتداد"""
        ext = pathlib.Path(filename).suffix.lower()
        return self.code_extensions.get(ext, 'Unknown')
    
    def format_size(self, size_bytes: int) -> str:
        """تنسيق حجم الملف بشكل مقروء"""
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size_bytes < 1024.0:
                return f"{size_bytes:.1f} {unit}"
            size_bytes /= 1024.0
        return f"{size_bytes:.1f} TB"
    
    def read_file_safely(self, filepath: str) -> str:
        """قراءة الملف بشكل آمن مع معالجة الأخطاء"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                return f.read()
        except UnicodeDecodeError:
            try:
                with open(filepath, 'r', encoding='latin-1') as f:
                    return f.read()
            except:
                return "# [خطأ: لا يمكن قراءة الملف بتنسيق نصي]\n"
        except Exception as e:
            return f"# [خطأ في قراءة الملف: {str(e)}]\n"
    
    def scan_project(self) -> List[Dict]:
        """مسح المشروع وجمع الملفات"""
        print("🔍 جاري مسح مشروع Flutter...")
        
        all_files = []
        
        for root, dirs, files in os.walk(self.project_path):
            # إزالة المجلدات المستبعدة من البحث
            dirs[:] = [d for d in dirs if d not in self.exclude_dirs]
            
            for file in files:
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, self.project_path)
                
                # استبعاد الملفات غير المرغوبة
                if self.should_exclude(filepath):
                    continue
                
                # الحصول على امتداد الملف
                ext = pathlib.Path(file).suffix.lower()
                
                # تضمين فقط ملفات الكود والتهيئة
                if ext in self.code_extensions:
                    try:
                        # الحصول على معلومات الملف
                        stat = os.stat(filepath)
                        file_size = stat.st_size
                        file_type = self.get_file_type(file)
                        
                        file_info = {
                            'path': filepath,
                            'rel_path': rel_path,
                            'name': file,
                            'size': file_size,
                            'type': file_type,
                            'extension': ext,
                            'folder': os.path.dirname(rel_path),
                            'lines': 0,
                            'content': None
                        }
                        
                        # حساب عدد الأسطر
                        try:
                            with open(filepath, 'r', encoding='utf-8') as f:
                                file_info['lines'] = sum(1 for _ in f)
                        except:
                            try:
                                with open(filepath, 'r', encoding='latin-1') as f:
                                    file_info['lines'] = sum(1 for _ in f)
                            except:
                                file_info['lines'] = 0
                        
                        all_files.append(file_info)
                        
                        # تحديث الإحصائيات
                        self.stats['total_files'] += 1
                        self.stats['total_lines'] += file_info['lines']
                        self.stats['total_size'] += file_size
                        
                        # تحديث الإحصائيات حسب النوع
                        file_type_name = self.code_extensions.get(ext, 'Other')
                        self.stats['files_by_type'][file_type_name] = \
                            self.stats['files_by_type'].get(file_type_name, 0) + 1
                        
                        # تحديث الإحصائيات حسب المجلد
                        folder = os.path.dirname(rel_path)
                        if folder:
                            self.stats['files_by_folder'][folder] = \
                                self.stats['files_by_folder'].get(folder, 0) + 1
                        
                    except Exception as e:
                        print(f"⚠️  خطأ في معالجة {rel_path}: {e}")
        
        # ترتيب الملفات حسب الأولوية
        all_files.sort(key=lambda x: self.get_file_priority(x['rel_path']))
        
        return all_files
    
    def get_file_priority(self, rel_path: str) -> int:
        """الحصول على أولوية الملف للترتيب"""
        # أولويات عالية للمجلدات المهمة
        for i, folder in enumerate(self.priority_folders):
            if rel_path.startswith(folder):
                return i
        
        # أولوية منخفضة للملفات في المجلد الجذر
        if os.path.dirname(rel_path) == '':
            return 100
        
        # أولوية متوسطة لباقي الملفات
        return 200
    
    def extract_files_content(self, files: List[Dict]) -> None:
        """استخراج محتوى الملفات وحفظها"""
        print(f"📝 جاري استخراج {len(files)} ملف...")
        
        with open(self.output_file, 'w', encoding='utf-8') as outfile:
            # كتابة الترويسة
            outfile.write("=" * 80 + "\n")
            outfile.write("مستخرج أكواد مشروع Flutter\n")
            outfile.write("=" * 80 + "\n\n")
            
            outfile.write(f"📋 اسم المشروع: {self.project_name}\n")
            outfile.write(f"📁 المسار: {self.project_path}\n")
            outfile.write(f"📅 التاريخ: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            outfile.write(f"🔢 عدد الملفات: {self.stats['total_files']}\n")
            outfile.write(f"📊 إجمالي الأسطر: {self.stats['total_lines']:,}\n")
            outfile.write(f"💾 الحجم الإجمالي: {self.format_size(self.stats['total_size'])}\n\n")
            
            # كتابة الفهرس
            outfile.write("=" * 80 + "\n")
            outfile.write("📑 الفهرس\n")
            outfile.write("=" * 80 + "\n\n")
            
            current_folder = None
            file_counter = 1
            
            for file_info in files:
                if file_info['folder'] != current_folder:
                    current_folder = file_info['folder']
                    folder_display = current_folder if current_folder else "[الجذر]"
                    outfile.write(f"\n📂 مجلد: {folder_display}\n")
                    outfile.write("-" * 60 + "\n")
                
                outfile.write(f"{file_counter:3d}. 📄 {file_info['rel_path']} ")
                outfile.write(f"({self.format_size(file_info['size'])}, ")
                outfile.write(f"{file_info['lines']:,} سطر)\n")
                file_counter += 1
            
            # كتابة محتوى الملفات
            outfile.write("\n" + "=" * 80 + "\n")
            outfile.write("📄 محتوى الملفات\n")
            outfile.write("=" * 80 + "\n\n")
            
            file_counter = 1
            for file_info in files:
                outfile.write("=" * 80 + "\n")
                outfile.write(f"الملف {file_counter}: {file_info['rel_path']}\n")
                outfile.write("-" * 80 + "\n")
                outfile.write(f"المسار الكامل: {file_info['path']}\n")
                outfile.write(f"نوع الملف: {file_info['type']}\n")
                outfile.write(f"الحجم: {self.format_size(file_info['size'])}\n")
                outfile.write(f"عدد الأسطر: {file_info['lines']:,}\n")
                outfile.write("=" * 80 + "\n\n")
                
                # قراءة محتوى الملف
                content = self.read_file_safely(file_info['path'])
                outfile.write(content)
                
                # إضافة فاصل إذا لم يكن هناك سطر فارغ في النهاية
                if content and not content.endswith('\n'):
                    outfile.write('\n')
                
                outfile.write("\n" + "=" * 80 + "\n")
                outfile.write(f"نهاية الملف: {file_info['rel_path']}\n")
                outfile.write("=" * 80 + "\n\n\n")
                
                file_counter += 1
                print(f"  ✅ تم معالجة: {file_info['rel_path']}")
            
            # كتابة الإحصائيات النهائية
            outfile.write("=" * 80 + "\n")
            outfile.write("📊 الإحصائيات النهائية\n")
            outfile.write("=" * 80 + "\n\n")
            
            outfile.write("📈 الملفات حسب النوع:\n")
            for file_type, count in sorted(self.stats['files_by_type'].items()):
                outfile.write(f"  • {file_type}: {count} ملف\n")
            
            outfile.write("\n📂 الملفات حسب المجلد (أعلى 10):\n")
            sorted_folders = sorted(
                self.stats['files_by_folder'].items(),
                key=lambda x: x[1],
                reverse=True
            )[:10]
            
            for folder, count in sorted_folders:
                outfile.write(f"  • {folder}: {count} ملف\n")
            
            outfile.write("\n" + "=" * 80 + "\n")
            outfile.write("🎉 تم الانتهاء من الاستخراج بنجاح!\n")
            outfile.write("=" * 80 + "\n")
    
    def print_summary(self) -> None:
        """طباعة ملخص العملية"""
        print("\n" + "=" * 60)
        print("📊 ملخص الاستخراج")
        print("=" * 60)
        
        print(f"📂 المشروع: {self.project_name}")
        print(f"📁 المسار: {self.project_path}")
        print(f"💾 ملف الإخراج: {self.output_file}")
        print(f"📦 حجم الملف: {self.format_size(os.path.getsize(self.output_file))}")
        print(f"📄 عدد الملفات المستخرجة: {self.stats['total_files']:,}")
        print(f"📊 إجمالي الأسطر: {self.stats['total_lines']:,}")
        
        print("\n📈 توزيع الملفات حسب النوع:")
        for file_type, count in sorted(self.stats['files_by_type'].items()):
            print(f"  • {file_type}: {count} ملف")
        
        print("\n🎯 الملفات حسب الامتداد:")
        extensions_count = {}
        for file_type, count in self.stats['files_by_type'].items():
            # البحث عن الامتداد المقابل
            for ext, name in self.code_extensions.items():
                if name == file_type:
                    extensions_count[ext] = count
                    break
        
        for ext, count in sorted(extensions_count.items()):
            print(f"  • {ext}: {count} ملف")
        
        print("\n" + "=" * 60)
        print("🚀 أوامر مفيدة:")
        print("=" * 60)
        print(f"  📖 لعرض الملف: less {self.output_file}")
        print(f"  🔍 للبحث في الملف: grep -n 'كلمة' {self.output_file}")
        print(f"  📊 لعرض الإحصائيات: wc -l {self.output_file}")
        print(f"  📋 لنسخ الملف: cp {self.output_file} ~/storage/downloads/")
        print(f"  📁 لعرض هيكل المشروع: find . -name '*.dart' | wc -l")
        print("=" * 60)
    
    def run(self) -> bool:
        """تشغيل عملية الاستخراج"""
        print("🚀 بدء استخراج أكواد Flutter...")
        print("=" * 60)
        
        try:
            # التحقق من وجود المشروع
            if not os.path.exists(self.project_path):
                print(f"❌ المسار غير موجود: {self.project_path}")
                return False
            
            # التحقق من وجود pubspec.yaml (مشروع Flutter)
            pubspec_path = os.path.join(self.project_path, 'pubspec.yaml')
            if not os.path.exists(pubspec_path):
                print("⚠️  تحذير: لم يتم العثور على pubspec.yaml")
                print("هل أنت في مجلد مشروع Flutter الصحيح؟")
                response = input("المتابرة على أي حال؟ (y/n): ")
                if response.lower() != 'y':
                    return False
            
            # مسح المشروع
            files = self.scan_project()
            
            if not files:
                print("❌ لم يتم العثور على ملفات لاستخراجها")
                return False
            
            # استخراج المحتوى
            self.extract_files_content(files)
            
            # عرض الملخص
            self.print_summary()
            
            return True
            
        except KeyboardInterrupt:
            print("\n\n⏹️  تم إيقاف العملية بواسطة المستخدم")
            return False
        except Exception as e:
            print(f"\n❌ حدث خطأ: {e}")
            import traceback
            traceback.print_exc()
            return False

def main():
    """الدالة الرئيسية"""
    # عرض الترويسة
    print("\n" + "=" * 60)
    print("📱 مستخرج أكواد Flutter - إصدار Python")
    print("=" * 60)
    
    # الحصول على مسار المشروع
    if len(sys.argv) > 1:
        project_path = sys.argv[1]
    else:
        project_path = input("أدخل مسار مشروع Flutter (اضغط Enter للاستخدام الحالي): ").strip()
        if not project_path:
            project_path = "."
    
    # إنشاء المستخرج وتشغيله
    extractor = FlutterCodeExtractor(project_path)
    success = extractor.run()
    
    if success:
        print("\n✅ تم الانتهاء بنجاح!")
        sys.exit(0)
    else:
        print("\n❌ فشل الاستخراج")
        sys.exit(1)

if __name__ == "__main__":
    main()
