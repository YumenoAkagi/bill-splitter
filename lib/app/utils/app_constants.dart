import 'package:supabase_flutter/supabase_flutter.dart';

const APP_NAME = 'Bill Splitter';

// supabase configs
final supabaseClient = Supabase.instance.client;

// dictionary keys
const SESSION_KEY = 'Session';
const THEME_KEY = 'Theme';

// font family
const MAIN_FONT = 'Lato';

// app color palettes
const COLOR_1 = '#695F94'; // mostly used as image or background color
const COLOR_2 = '#2D2747'; // mostly used for button primary color
const COLOR_3 = '#B2A6E0';
const COLOR_4 = '#47431F';
const COLOR_5 = '#948E5F'; // warnings + quick action

const COLOR_DARK_MAIN = '#303030';

// calculations and numbers
const GOLDEN_RATIO = 1.61803398875;
const INTMAXVALUE = 9007199254740991;

// widget sizes
const BUTTON_MINHEIGHT = 30 * GOLDEN_RATIO;
const BUTTON_BORDER_RAD = 6 * GOLDEN_RATIO;
const BUTTON_ICON_SIZE = 12 * GOLDEN_RATIO;
const CONTAINER_MARGIN_HORIZONTAL = 35 * GOLDEN_RATIO;
const CONTAINER_MARGIN_VERTICAL = 25 * GOLDEN_RATIO;
const SAFEAREA_CONTAINER_MARGIN_H = 15 * GOLDEN_RATIO;
const SAFEAREA_CONTAINER_MARGIN_V = 5 * GOLDEN_RATIO;
const TEXTFORMFIELD_BORDER_RAD = 8 * GOLDEN_RATIO;

// text & labels
const retrievingDataStatusTxt = 'Retrieving data...';
