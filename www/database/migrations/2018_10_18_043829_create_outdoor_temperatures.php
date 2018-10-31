<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateOutdoorTemperatures extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('outdoor_temperatures', function (Blueprint $table) {
            $table->increments('id');
	    $table->string('temperature');
	    $table->timestamps();

	    $table->index('temperature');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('outdoor_temperatures');
    }
}
