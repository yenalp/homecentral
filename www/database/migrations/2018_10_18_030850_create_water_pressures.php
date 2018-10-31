<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateWaterPressures extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('water_pressures', function (Blueprint $table) {
            $table->increments('id');
	    $table->double('pressure')->nullable();;
	    $table->double('voltage')->nullable();;
	    $table->double('level_mm')->nullable();;
	    $table->double('level_percent')->nullable();;
	    $table->timestamps();

	    $table->index('pressure');
	    $table->index('voltage');
	    $table->index('level_mm');
	    $table->index('level_percent');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('water_pressures');
    }
}
