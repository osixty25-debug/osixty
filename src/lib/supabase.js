import { createClient } from '@supabase/supabase-js'

const url = 'https://ibgbqlcoajasacuglsmw.supabase.co'
const key = 'sb_publishable_D4hPXze7FQki8w4V6bCPyg_XSZ8TEp3'

export const supabase = createClient(url, key)