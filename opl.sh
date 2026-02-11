#!/data/data/com.termux/files/usr/bin/bash

# سكربت استخراج أكواد Flutter لمشروعك الخاص
# ===========================================

# إعدادات
PROJECT_NAME="flutter_trading_app"
OUTPUT_FILE="${PROJECT_NAME}_codes_$(date +%Y%m%d_%H%M%S).txt"
TEMP_FILE="temp_codes.txt"

# قائمة بالمجلدات المهمة في مشروعك (بناءً على ما رأيته)
IMPORTANT_DIRS="lib scripts integration_test test android ios macos windows assets docs"

# الملفات الإضافية المهمة
IMPORTANT_FILES="pubspec.yaml pubspec.lock analysis_options.yaml build.yaml README.md flutter_trading_app.iml"

# مجلدات يجب استبعادها
EXCLUDE_DIRS="build .dart_tool .git .idea __pycache__ node_modules tmp*"

# ملفات يجب استبعادها
EXCLUDE_FILES="*.apk *.ipa *.img *.so *.o *.a *.pyc *.lock *.patch"

# دالة لعرض التقدم
print_progress() {
    echo "▶ $1"
}

# دالة لعرض الخطأ
print_error() {
    echo "❌ $1"
}

# دالة لعرض النجاح
print_success() {
    echo "✅ $1"
}

# دالة لعرض المعلومات
print_info() {
    echo "ℹ️ $1"
}

# تنظيف الشاشة وبدء البرنامج
clear
echo "=========================================="
echo "   سكربت استخراج أكواد Flutter"
echo "   لمشروع: $PROJECT_NAME"
echo "=========================================="
echo ""

# التحقق من وجود مشروع Flutter
if [ ! -f "pubspec.yaml" ]; then
    print_error "لا يوجد ملف pubspec.yaml في المجلد الحالي!"
    print_info "يرجى التأكد من أنك في مجلد مشروع Flutter الصحيح"
    exit 1
fi

# عرض هيكل المشروع
print_info "هيكل المشروع المحدد:"
echo "------------------------------------------"
for dir in $IMPORTANT_DIRS; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -type f -name "*.dart" 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            echo "📁 $dir/ ($count ملف Dart)"
        else
            echo "📁 $dir/"
        fi
    fi
done
echo "------------------------------------------"

# إنشاء ملف الإخراج
print_progress "إنشاء ملف الإخراج: $OUTPUT_FILE"
> "$OUTPUT_FILE"

# كتابة رأس الملف
{
    echo "# =========================================="
    echo "# استخراج أكواد مشروع Flutter"
    echo "# اسم المشروع: $PROJECT_NAME"
    echo "# تاريخ الاستخراج: $(date)"
    echo "# المسار: $(pwd)"
    echo "# =========================================="
    echo ""
    echo "# الفهرس:"
    echo ""
} >> "$OUTPUT_FILE"

# عداد الملفات
total_files=0
dart_files=0
other_files=0

# دالة لاستخراج محتوى الملف مع المعلومات
extract_file() {
    local file_path="$1"
    local relative_path="${file_path#./}"
    
    # الحصول على معلومات الملف
    local file_name=$(basename "$file_path")
    local file_dir=$(dirname "$relative_path")
    local file_size=$(du -h "$file_path" 2>/dev/null | cut -f1 || echo "غير معروف")
    local file_lines=$(wc -l < "$file_path" 2>/dev/null || echo "0")
    
    # كتابة معلومات الملف في الإخراج
    {
        echo ""
        echo "# =========================================="
        echo "# ملف: $relative_path"
        echo "# المجلد: $file_dir"
        echo "# الاسم: $file_name"
        echo "# الحجم: $file_size"
        echo "# عدد الأسطر: $file_lines"
        echo "# =========================================="
        echo ""
    } >> "$OUTPUT_FILE"
    
    # إضافة محتوى الملف
    cat "$file_path" >> "$OUTPUT_FILE" 2>/dev/null
    
    # إضافة فاصل
    echo "" >> "$OUTPUT_FILE"
    echo "# --- نهاية ملف: $file_name ---" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # زيادة العداد
    ((total_files++))
    
    # عرض التقدم
    echo "  ↳ تم معالجة: $relative_path"
}

# 1. معالجة ملفات Dart في المجلدات المهمة
print_progress "جاري استخراج ملفات Dart..."
for dir in $IMPORTANT_DIRS; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -type f -name "*.dart" 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            print_info "معالجة مجلد: $dir (يوجد $count ملف Dart)"
            
            # إضافة عنوان المجلد إلى الفهرس
            echo "# 📁 $dir/" >> "$OUTPUT_FILE"
            
            # البحث عن ملفات Dart في هذا المجلد
            while IFS= read -r file; do
                # تخطي الملفات في المجلدات المستبعدة
                skip=0
                for exclude in $EXCLUDE_DIRS; do
                    if [[ "$file" == *"/$exclude/"* ]]; then
                        skip=1
                        break
                    fi
                done
                
                if [ $skip -eq 0 ]; then
                    extract_file "$file"
                    ((dart_files++))
                    
                    # إضافة إلى الفهرس
                    echo "#   📄 ${file#./}" >> "$TEMP_FILE" 2>/dev/null
                fi
            done < <(find "$dir" -type f -name "*.dart" 2>/dev/null | sort)
        fi
    fi
done

# 2. معالجة الملفات الإضافية المهمة
print_progress "جاري استخراج الملفات الإضافية المهمة..."
{
    echo ""
    echo "# =========================================="
    echo "# الملفات الإضافية المهمة"
    echo "# =========================================="
    echo ""
} >> "$OUTPUT_FILE"

for file in $IMPORTANT_FILES; do
    if [ -f "$file" ]; then
        print_info "معالجة ملف: $file"
        extract_file "$file"
        ((other_files++))
    fi
done

# 3. معالجة ملفات YAML والتهيئة
print_progress "جاري استخراج ملفات التهيئة..."
yaml_files=$(find . -type f \( -name "*.yaml" -o -name "*.yml" \) ! -path "./$OUTPUT_FILE" 2>/dev/null | grep -vE "$(echo $EXCLUDE_DIRS | sed 's/ /|/g')")
if [ -n "$yaml_files" ]; then
    {
        echo ""
        echo "# =========================================="
        echo "# ملفات التهيئة (YAML/YML)"
        echo "# =========================================="
        echo ""
    } >> "$OUTPUT_FILE"
    
    while IFS= read -r file; do
        # تخطي إذا كان ملف الإخراج
        if [[ "$file" == "./$OUTPUT_FILE" ]]; then
            continue
        fi
        
        # تخطي الملفات المستبعدة
        skip=0
        for exclude in $EXCLUDE_DIRS; do
            if [[ "$file" == *"/$exclude/"* ]]; then
                skip=1
                break
            fi
        done
        
        if [ $skip -eq 0 ]; then
            extract_file "$file"
            ((other_files++))
        fi
    done <<< "$yaml_files"
fi

# 4. معالجة ملفات البرمجة الأخرى
print_progress "جاري استخراج ملفات البرمجة الأخرى..."
{
    echo ""
    echo "# =========================================="
    echo "# ملفات البرمجة الأخرى"
    echo "# =========================================="
    echo ""
} >> "$OUTPUT_FILE"

# البحث عن ملفات برمجة شائعة
code_extensions="*.py *.sh *.bash *.js *.ts *.java *.kt *.swift *.cpp *.c *.h"
for ext in $code_extensions; do
    files=$(find . -type f -name "$ext" ! -path "./$OUTPUT_FILE" 2>/dev/null | head -20)
    if [ -n "$files" ]; then
        while IFS= read -r file; do
            # تخطي الملفات في المجلدات المستبعدة
            skip=0
            for exclude in $EXCLUDE_DIRS; do
                if [[ "$file" == *"/$exclude/"* ]]; then
                    skip=1
                    break
                fi
            done
            
            if [ $skip -eq 0 ]; then
                extract_file "$file"
                ((other_files++))
            fi
        done <<< "$files"
    fi
done

# 5. تحديث الفهرس في بداية الملف
print_progress "جاري تحديث الفهرس..."
if [ -f "$TEMP_FILE" ]; then
    cat "$TEMP_FILE" >> "$OUTPUT_FILE".tmp
    mv "$OUTPUT_FILE".tmp "$OUTPUT_FILE"
    rm -f "$TEMP_FILE"
fi

# 6. إضافة ملخص في النهاية
{
    echo ""
    echo "# =========================================="
    echo "# ملخص الاستخراج"
    echo "# =========================================="
    echo "#"
    echo "# إحصائيات:"
    echo "#   • إجمالي الملفات المعالجة: $total_files"
    echo "#   • ملفات Dart: $dart_files"
    echo "#   • ملفات أخرى: $other_files"
    echo "#"
    echo "# المجلدات الرئيسية:"
} >> "$OUTPUT_FILE"

for dir in $IMPORTANT_DIRS; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -type f ! -name "*.DS_Store" 2>/dev/null | wc -l)
        dart_count=$(find "$dir" -type f -name "*.dart" 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            echo "#   • $dir/: $count ملف (بما في ذلك $dart_count Dart)" >> "$OUTPUT_FILE"
        fi
    fi
done

{
    echo "#"
    echo "# تم إنشاء هذا الملف بواسطة سكربت استخراج أكواد Flutter"
    echo "# =========================================="
} >> "$OUTPUT_FILE"

# حساب حجم الملف
file_size=$(du -h "$OUTPUT_FILE" 2>/dev/null | cut -f1 || echo "غير معروف")
line_count=$(wc -l < "$OUTPUT_FILE" 2>/dev/null || echo "0")

# عرض النتائج النهائية
echo ""
echo "=========================================="
print_success "اكتمل استخراج الأكواد بنجاح!"
echo "=========================================="
echo ""
print_info "تفاصيل الإخراج:"
echo "  • اسم الملف: $OUTPUT_FILE"
echo "  • حجم الملف: $file_size"
echo "  • عدد الأسطر: $line_count"
echo "  • عدد الملفات المعالجة: $total_files"
echo ""
print_info "توزيع الملفات:"
echo "  • ملفات Dart: $dart_files"
echo "  • ملفات أخرى: $other_files"
echo ""
print_info "أوامر مفيدة:"
echo "  • لعرض الملف: less $OUTPUT_FILE"
echo "  • للبحث في الملف: grep -n 'كلمة' $OUTPUT_FILE"
echo "  • لنسخ الملف: cp $OUTPUT_FILE ~/storage/downloads/"
echo "  • لحساب حجم المشروع: du -sh ."
echo ""
print_info "لرؤية الملفات المستخرجة حسب النوع:"
echo "  • ملفات Dart: find . -name '*.dart' | wc -l"
echo "  • ملفات YAML: find . -name '*.yaml' -o -name '*.yml' | wc -l"
echo ""
echo "=========================================="
