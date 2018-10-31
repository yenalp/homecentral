<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 *  @SuppressWarnings(PHPMD.NumberOfChildren)
 */
class BaseModel extends Model
{
    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
    }
}
