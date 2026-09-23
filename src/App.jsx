
import { useEffect, useState } from 'react'
import { supabase } from './lib/supabase'

export default function App(){
  const [status, setStatus] = useState('جاري الاتصال بقاعدة البيانات...')
  const [users, setUsers] = useState([])
  
  useEffect(()=>{
    async function test(){
      const { data, error } = await supabase.from('users').select('*').limit(5)
      if(error){ setStatus('خطأ: '+error.message) }
      else { setStatus('✅ متصل بنجاح! عدد المستخدمين: '+data.length); setUsers(data) }
    }
    test()
  },[])

  return (
    <div style={{fontFamily:'Cairo, sans-serif', padding:20, direction:'rtl'}}>
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold text-cyan-600">BREEZE VENUE OS - مربوط بقاعدتك</h1>
        <p className="mt-2 p-3 bg-slate-100 rounded">{status}</p>
        
        <div className="mt-4 grid grid-cols-1 gap-2">
          {users.map(u=> <div key={u.id} className="p-2 border rounded flex justify-between"><span>{u.username}</span><span>{u.role}</span></div>)}
        </div>

        <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded">
          <h2 className="font-bold">الخطوة الجاية:</h2>
          <ol className="list-decimal mr-6 mt-2 space-y-2 text-sm">
            <li>اعمل <b>npm install</b> ثم <b>npm run dev</b> عشان تشغل المشروع على جهازك</li>
            <li>افتح الملف <b>src/App.jsx</b> الحالي واستبدله بالكود الكامل للسيستم اللي بنيتهولك (هتلاقيه في الملف المرفق App-full.jsx)</li>
            <li>ارفعه على GitHub و Vercel كما شرحنا</li>
          </ol>
        </div>

        <div className="mt-6">
          <h3 className="font-bold">السيستم الكامل شغال هنا - نسخة الويب:</h3>
          <p className="text-sm text-gray-600">افتح الملف breeze-venue-os-v2_agentic_artifact_2_491bbc67e6b9.html اللي في التحميل السابق - هو نفس السيستم لكن مربوط الان بـ Supabase عبر المفاتيح اللي في .env</p>
          <a href="https://ibgbqlcoajasacuglsmw.supabase.co" target="_blank" className="text-cyan-600 underline">افتح Supabase Dashboard</a>
        </div>
      </div>
    </div>
  )
}
