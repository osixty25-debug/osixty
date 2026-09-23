# BREEZE VENUE OS V2 - خطوات الرفع على GitHub و Vercel

## بعد ما عملت SQL واتاكدت ان الجداول موجودة

### 1. خد المفاتيح من Supabase
- Project Settings > API > انسخ URL و anon key

### 2. نزل المشروع الجاهز
- هبعتلك ملف breeze-venue.zip

### 3. ارفعه على GitHub
1. ادخل github.com > New Repository > سميه breeze-venue > Create
2. دوس Upload files واسحب كل ملفات المشروع
3. دوس Commit

### 4. شغله على Vercel
1. vercel.com > Login with GitHub
2. Add New Project > اختار breeze-venue
3. Environment Variables > ضيف:
   VITE_SUPABASE_URL = https://xxx.supabase.co
   VITE_SUPABASE_ANON_KEY = eyJxxxx
4. Deploy

هيطلعلك لينك عام للنادي.

## اليوزرات الافتراضية
admin / Admin@123
security / Sec@123
reception / Rec@123
cashier / Cash@123
accounts / Acc@123
