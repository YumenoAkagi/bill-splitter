import 'package:supabase_flutter/supabase_flutter.dart';

const APP_NAME = 'Bill Splitter';

// supabase configs
final supabaseClient = Supabase.instance.client;

const SUPABASE_URL = 'https://whcqnwfmyrmwjdnuarqf.supabase.co/';
const SUPABASE_ANONKEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndoY3Fud2ZteXJtd2pkbnVhcnFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg5NzY2NTMsImV4cCI6MTk5NDU1MjY1M30.4NlfYXMM7fkeGjcPDToOnEZ0SghxxzU3rxW-BIPNM3I';

// dictionary keys
const SESSION_KEY = 'Session';

// font family
const MAIN_FONT = 'Lato';

// app color palettes
const COLOR_1 = '#695F94'; // mostly used as image or background color
const COLOR_2 = '#2D2747'; // mostly used for button primary color
const COLOR_3 = '#B2A6E0';
const COLOR_4 = '#47431F';
const COLOR_5 = '#948E5F'; // warnings + quick action

// calculations and numbers
const GOLDEN_RATIO = 1.61803398875;

// widget sizes
const BUTTON_MINHEIGHT = 30 * GOLDEN_RATIO;
const BUTTON_BORDER_RAD = 6 * GOLDEN_RATIO;
const BUTTON_ICON_SIZE = 10 * GOLDEN_RATIO;
const CONTAINER_MARGIN_HORIZONTAL = 35 * GOLDEN_RATIO;
const CONTAINER_MARGIN_VERTICAL = 25 * GOLDEN_RATIO;
const SAFEAREA_CONTAINER_MARGIN_H = 10 * GOLDEN_RATIO;
const SAFEAREA_CONTAINER_MARGIN_V = 5 * GOLDEN_RATIO;
const TEXTFORMFIELD_BORDER_RAD = 8 * GOLDEN_RATIO;
