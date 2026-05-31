// Barrel file: single import that re-exports app modules and common packages.

// Core utilities
export 'package:safeandromeda/core/utils/app_settings.dart';
export 'package:safeandromeda/core/utils/app_color.dart';
export 'package:safeandromeda/core/utils/app_text.dart';
export 'package:safeandromeda/core/utils/response.dart';

// Providers
export 'package:safeandromeda/core/provider/scroll_provider.dart';
export 'package:safeandromeda/core/provider/animation_provider.dart';
export 'package:safeandromeda/core/provider/cursor_provider.dart';

// Pages
export 'package:safeandromeda/pages/journey/journey_page.dart';
export 'package:safeandromeda/pages/eras/big_bang.dart';
export 'package:safeandromeda/pages/eras/dark_ages.dart';
export 'package:safeandromeda/pages/eras/first_stars.dart';
export 'package:safeandromeda/pages/eras/galaxies.dart';
export 'package:safeandromeda/pages/eras/solar_system.dart';
export 'package:safeandromeda/pages/eras/life_begins.dart';
export 'package:safeandromeda/pages/eras/age_of_giants.dart';
export 'package:safeandromeda/pages/eras/humanity.dart';
export 'package:safeandromeda/pages/eras/future.dart';
export 'package:safeandromeda/pages/portfolio/portfolio_reveal.dart';

// Layouts
export 'package:safeandromeda/layouts/eras/desktop.dart';
export 'package:safeandromeda/layouts/eras/tablet.dart';
export 'package:safeandromeda/layouts/eras/mobile.dart';
export 'package:safeandromeda/layouts/portfolio/desktop.dart';
export 'package:safeandromeda/layouts/portfolio/tablet.dart';
export 'package:safeandromeda/layouts/portfolio/mobile.dart';

// Components
export 'package:safeandromeda/components/journey/progress_bar.dart';
export 'package:safeandromeda/components/journey/era_wrapper.dart';
export 'package:safeandromeda/components/journey/era_scope.dart';
export 'package:safeandromeda/components/interactive/star_igniter.dart';
export 'package:safeandromeda/components/interactive/galaxy_rotator.dart';
export 'package:safeandromeda/components/interactive/creature_revealer.dart';
export 'package:safeandromeda/components/painters/star_field_painter.dart';
export 'package:safeandromeda/components/painters/nebula_painter.dart';
export 'package:safeandromeda/components/painters/particle_painter.dart';
export 'package:safeandromeda/components/painters/orbit_painter.dart';
export 'package:safeandromeda/components/painters/foreground_painter.dart';
export 'package:safeandromeda/components/painters/info_label_painter.dart';

// Interactive painters
export 'package:safeandromeda/components/interactive/painters/creature_silhouette_painter.dart';
export 'package:safeandromeda/components/interactive/painters/titan_dust_painter.dart';
export 'package:safeandromeda/components/interactive/painters/galaxy_spiral_painter.dart';
export 'package:safeandromeda/components/interactive/painters/ignited_stars_painter.dart';

// Journey painters
export 'package:safeandromeda/pages/journey/painters/cursor_trail_painter.dart';

// Era painters
export 'package:safeandromeda/pages/eras/painters/shockwave_painter.dart';
export 'package:safeandromeda/pages/eras/painters/radial_streak_painter.dart';
export 'package:safeandromeda/pages/eras/painters/expanding_rings_painter.dart';
export 'package:safeandromeda/pages/eras/painters/cosmic_dust_painter.dart';
export 'package:safeandromeda/pages/eras/painters/density_seeds_painter.dart';
export 'package:safeandromeda/pages/eras/painters/constellation_painter.dart';
export 'package:safeandromeda/pages/eras/painters/supernovae_painter.dart';
export 'package:safeandromeda/pages/eras/painters/star_birth_painter.dart';
export 'package:safeandromeda/pages/eras/painters/drifting_galaxies_painter.dart';
export 'package:safeandromeda/pages/eras/painters/solar_system_painter.dart';
export 'package:safeandromeda/pages/eras/painters/dna_helix_painter.dart';
export 'package:safeandromeda/pages/eras/painters/microbes_painter.dart';
export 'package:safeandromeda/pages/eras/painters/scenery_painter.dart';
export 'package:safeandromeda/pages/eras/painters/ground_fog_painter.dart';
export 'package:safeandromeda/pages/eras/painters/dinos_painter.dart';
export 'package:safeandromeda/pages/eras/painters/river_painter.dart';
export 'package:safeandromeda/pages/eras/painters/wind_trees_painter.dart';
export 'package:safeandromeda/pages/eras/painters/fish_painter.dart';
export 'package:safeandromeda/pages/eras/painters/forest_fliers_painter.dart';
export 'package:safeandromeda/pages/eras/painters/humanity_story_painter.dart';
export 'package:safeandromeda/pages/eras/painters/future_tech_painter.dart';
export 'package:safeandromeda/pages/eras/painters/data_stream_painter.dart';

// Packages
export 'dart:async';
export 'dart:math';
export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:url_launcher/url_launcher.dart';
