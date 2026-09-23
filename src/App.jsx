import { useState, useEffect } from 'react'
import { supabase } from './lib/supabase'

export default function App(){
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [user, setUser] = useState(JSON.parse(localStorage.getItem('breeze_current_user') || 'null'))
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const login = async () => {
    setLoading(true)
    setError('')
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .eq('username', username)
      .eq('password', password)
      .single()
    
    if(error || !data){
      setError('اليوزر او الباسورد غلط - جرب: admin / Admin@123')
      setLoading(false)
    } else {
      localStorage.setItem('breeze_current_user', JSON.stringify(data))
      setUser(data)
      setLoading(false)
      await supabase.from('system_logs').insert({
        action: 'تسجيل دخول',
        user_name: data.username,
        user_role: data.role,
        details: 'من المتصفح'
      })
    }
  }

  const logout = () => {
    localStorage.removeItem('breeze_current_user')
    setUser(null)
  }

  if(!user){
    return (
      <div style={{minHeight:'100vh', display:'flex', alignItems:'center', justifyContent:'center', background:'#0f172a', fontFamily:'Cairo'}}>
        <div style={{background:'white', padding:32, borderRadius:16, width:360, boxShadow:'0 20px 60px rgba(0,0,0,0.3)'}}>
          <div style={{textAlign:'center', marginBottom:20}}>
            <div style={{width:60, height:60, background:'#06b6d4', borderRadius:16, margin:'0 auto 12px', display:'flex', alignItems:'center', justifyContent:'center', fontSize:28}}>🌊</div>
            <h1 style={{fontWeight:'900', fontSize:22, letterSpacing:1}}>BREEZE VENUE</h1>
            <p style={{color:'#64748b', fontSize:12}}>نظام ادارة النادي - متصل بالسحابة</p>
          </div>
          <input value={username} onChange={e=>setUsername(e.target.value)} placeholder="اسم المستخدم" style={{width:'100%', padding:12, border:'1px solid #e2e8f0', borderRadius:10, marginBottom:12, outline:'none'}}/>
          <input type="password" value={password} onChange={e=>setPassword(e.target.value)} placeholder="كلمة المرور" style={{width:'100%', padding:12, border:'1px solid #e2e8f0', borderRadius:10, marginBottom:12, outline:'none'}}/>
          {error && <p style={{color:'#ef4444', fontSize:12, marginBottom:10, background:'#fef2f2', padding:8, borderRadius:8}}>{error}</p>}
          <button onClick={login} disabled={loading} style={{width:'100%', background:'#06b6d4', color:'white', padding:12, borderRadius:10, fontWeight:'bold', cursor:'pointer'}}>
            {loading ? 'جاري التحقق...' : 'دخول'}
          </button>
          <div style={{marginTop:16, padding:10, background:'#f8fafc', borderRadius:8, fontSize:11, color:'#64748b'}}>
            <b>للتجربة:</b><br/>admin / Admin@123<br/>reception / Rec@123<br/>security / Sec@123
          </div>
        </div>
      </div>
    )
  }

  return (
    <div style={{padding:0, direction:'rtl'}}>
      <div style={{background:'#0f172a', color:'white', padding:'12px 20px', display:'flex', justifyContent:'space-between', alignItems:'center'}}>
        <span>مرحبا {user.full_name} - {user.role}</span>
        <button onClick={logout} style={{background:'#ef4444', padding:'6px 12px', borderRadius:8, fontSize:12}}>خروج</button>
      </div>
      <iframe src="/breeze-os-full.html" style={{width:'100%', height:'calc(100vh - 48px)', border:'none'}} title="Breeze OS"></iframe>
    </div>
  )
}