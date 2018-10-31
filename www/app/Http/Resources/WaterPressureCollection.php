<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\ResourceCollection;
use Illuminate\Http\Resources\Json\JsonResource;

class WaterPressureCollection extends JsonResource
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
	    "percent" => $this->level_percent,
	    "voltage" => $this->voltage,
	    "level_mm" => $this->level_mm,
	    "pressure" => $this->pressure,
	    "created_at" => $this->created_at,
        ];


    }
}


