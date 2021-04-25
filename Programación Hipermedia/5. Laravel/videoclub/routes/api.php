<?php

use App\Http\Controllers\APICatalogController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::put('v1/catalog/{id}/rent', [APICatalogController::class, 'putRent'])->middleware('auth.basic.once');
Route::put('v1/catalog/{id}/return', [APICatalogController::class, 'putReturn'])->middleware('auth.basic.once');
Route::get('v1/catalog', [APICatalogController::class, 'index']);
Route::get('v1/catalog/{id}', [APICatalogController::class, 'show']);
Route::apiResource('v1/catalog', APICatalogController::class)->middleware('auth.basic.once')->except(['index', 'show']);
