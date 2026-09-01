import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';


const supabaseURL = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_PUBLISHABLE_KEY;
console.log(supabaseURL);
const supabase = createClient(supabaseURL, supabaseKey);

const { error } = await supabase
    .from('issues')
    .insert({
        fandomurl: 'Fantastic_Four_Vol_1_1',
        storynum: 1,
        series: 'Fantastic Four',
        volume: 1,
        issuenum: 1,
        coverdate: '1961-11-01',
        releasedate: '1961-08-08',
        writer: 'Stan Lee',
        artist: 'Jack Kirby',
        colorist: 'Stan Goldberg',
        letterer: 'Artie Simek'
    });

console.log(error);