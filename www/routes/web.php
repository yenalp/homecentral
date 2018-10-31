<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

use App\Models\WaterPressure;;
use App\Http\Resources\WaterPressureCollection;


Auth::routes(['register' => false]);

Route::get('/water-pressure', function () {
    return new WaterPressureCollection(WaterPressure::latest('created_at')->first());
});

Route::get('/', 'HomeController@react');
//
//Route::get('/', function () {
//    return view('welcome');
//});
//
//Route::get('/fusioncharts', 'FusionCharts@home');
//
//Auth::routes();
//
//Route::get('/home', 'HomeController@index')->name('home');
//Route::get('/react', 'HomeController@react')->name('react');
