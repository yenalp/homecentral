<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class WaterPressure extends BaseModel 
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'water_pressures';
    
    /**
     * The list of attribute's that can be mass-assigned
     *
     * @var array
     */
    protected $fillable = [
        'pressure',
        'voltage',
        'level_mm',
        'level_percent',
        'updated_at',
        'created_at',
        'id',
    ];
    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'pressure' => 'double',
        'voltage' => 'double',
        'level_mm' => 'double',
        'level_percent' => 'double',
        'id' => 'integer',
    ];
    /**
     * The attributes that should be hidden.
     *
     * @var array
     */
    protected $hidden = [
        'created_at',
    ];
    public $fieldsToLog = [
        'pressure',
        'voltage',
        'level_mm',
        'level_percent',
        'disabled',
    ];

    /**
     * @SuppressWarnings(PHPMD.BooleanArgumentFlag)
     */
    public function save(array $options = [], $isLoggingOnSave = true)
    {
        parent::save($options, $isLoggingOnSave);
    }
}
