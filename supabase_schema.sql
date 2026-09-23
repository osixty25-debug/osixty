
-- BREEZE VENUE OS - Complete Supabase Schema V2
-- انسخ الكود ده كله في Supabase > SQL Editor > Run

-- 1. جدول المستخدمين (الموظفين والاعضاء)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin','security','reception','cashier','accounts','member')),
  full_name TEXT,
  phone TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. جدول الاعضاء
CREATE TABLE IF NOT EXISTS members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  membership_number TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  birth_date DATE,
  national_id TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE NOT NULL,
  address TEXT,
  membership_start DATE DEFAULT CURRENT_DATE,
  membership_end DATE,
  membership_status TEXT DEFAULT 'active' CHECK (membership_status IN ('active','expired','blocked')),
  photo_url TEXT,
  face_image TEXT, -- base64 للـ Face ID
  documents JSONB DEFAULT '[]',
  wallet_balance NUMERIC DEFAULT 0,
  family_members JSONB DEFAULT '[]', -- [{name, relation, birth_date, face_image}]
  user_id UUID REFERENCES users(id),
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. جدول الخدمات والاسعار
CREATE TABLE IF NOT EXISTS services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('membership','gym','court','pool','restaurant','other')),
  price_member NUMERIC NOT NULL,
  price_non_member NUMERIC NOT NULL,
  duration_days INT,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. جدول الاشتراكات
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id UUID REFERENCES members(id) ON DELETE CASCADE,
  service_id UUID REFERENCES services(id),
  service_name TEXT NOT NULL,
  price NUMERIC NOT NULL,
  start_date DATE DEFAULT CURRENT_DATE,
  end_date DATE,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. جدول الحجوزات (ملاعب)
CREATE TABLE IF NOT EXISTS bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id UUID REFERENCES members(id),
  member_name TEXT,
  court_type TEXT,
  booking_date DATE NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  price NUMERIC,
  status TEXT DEFAULT 'confirmed',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. جدول المعاملات المالية
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  receipt_number TEXT UNIQUE NOT NULL,
  member_id UUID REFERENCES members(id),
  member_name TEXT NOT NULL,
  services JSONB NOT NULL, -- [{name, price}]
  total_amount NUMERIC NOT NULL,
  payment_method TEXT CHECK (payment_method IN ('cash','visa','wallet')),
  cashier_name TEXT,
  type TEXT CHECK (type IN ('member','non_member')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. جدول سجل الدخول (البوابات)
CREATE TABLE IF NOT EXISTS checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  member_id UUID REFERENCES members(id),
  member_name TEXT NOT NULL,
  face_verified BOOLEAN DEFAULT true,
  entry_time TIMESTAMPTZ DEFAULT NOW(),
  gate_name TEXT DEFAULT 'Main Gate',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. جدول الاخبار والسجلات
CREATE TABLE IF NOT EXISTS news (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS system_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  action TEXT NOT NULL,
  user_role TEXT,
  user_name TEXT,
  details TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- بيانات اولية
INSERT INTO users (username, password, role, full_name) VALUES
('admin', 'Admin@123', 'admin', 'مدير النظام'),
('security', 'Sec@123', 'security', 'امن البوابات'),
('reception', 'Rec@123', 'reception', 'موظف الاستقبال'),
('cashier', 'Cash@123', 'cashier', 'الكاشير'),
('accounts', 'Acc@123', 'accounts', 'الحسابات')
ON CONFLICT (username) DO NOTHING;

INSERT INTO services (name, category, price_member, price_non_member, duration_days, description) VALUES
('عضوية سنوية فرد', 'membership', 5000, 0, 365, 'عضوية نادي لسنة كاملة'),
('عضوية سنوية عائلة', 'membership', 8000, 0, 365, 'اب + ام + 3 اطفال'),
('جيم شهري', 'gym', 600, 900, 30, 'اشتراك جيم شامل'),
('جيم يومي', 'gym', 50, 80, 1, 'تذكرة يوم'),
('ملعب بادل - ساعة', 'court', 300, 450, 1, 'حجز ملعب بادل'),
('ملعب كرة - ساعة', 'court', 400, 600, 1, 'حجز ملعب كرة'),
('حمام سباحة شهري', 'pool', 500, 750, 30, 'تدريب سباحة'),
('Day Use', 'other', 0, 250, 1, 'تذكرة دخول يوم كامل لغير الاعضاء')
ON CONFLICT DO NOTHING;

-- تفعيل الـ Realtime عشان الاشعارات الحية
ALTER PUBLICATION supabase_realtime ADD TABLE members, transactions, checkins, bookings;

-- RLS (افتحه للتجربة - اقفله في الانتاج)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE news ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for now" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON members FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON services FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON subscriptions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON bookings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON transactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON checkins FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON news FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for now" ON system_logs FOR ALL USING (true) WITH CHECK (true);
