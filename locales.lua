Locales = {
    ['bg'] = {
        -- Notifications
        ['already_rented'] = 'Вече имате наето превозно средство. Не можете да наемете друго.',
        ['no_spawn_space'] = 'Няма свободно място за спаун.',
        ['model_error'] = 'Грешка при зареждане на модела.',
        ['spawn_error'] = 'Неуспешно спаунване на превозното средство.',
        ['rental_success'] = 'Наехте %s. Карайте внимателно!',
        ['payment_success'] = 'Платихте $%s за наем.',
        ['insufficient_funds'] = 'Нямате достатъчно средства.',
        
        -- UI
        ['rent_vehicle'] = 'Наеми превозно средство',
        ['already_rented_ui'] = 'Вече имате наета кола',
        ['rent_button'] = 'Наеми',
        
        -- Blip
        ['blip_label'] = 'Rentals',
        
        -- Target
        ['target_label'] = 'Наеми превозно средство',
        
        -- Error messages
        ['invalid_rental_data'] = 'ld-rentals: invalid rental data'
    },
    
    ['en'] = {
        -- Notifications
        ['already_rented'] = 'You already have a rented vehicle. You cannot rent another one.',
        ['no_spawn_space'] = 'No free space for spawning.',
        ['model_error'] = 'Error loading model.',
        ['spawn_error'] = 'Failed to spawn vehicle.',
        ['rental_success'] = 'You rented %s. Drive carefully!',
        ['payment_success'] = 'You paid $%s for rental.',
        ['insufficient_funds'] = 'Insufficient funds.',
        
        -- UI
        ['rent_vehicle'] = 'Rent Vehicle',
        ['already_rented_ui'] = 'You already have a rented car',
        ['rent_button'] = 'Rent',
        
        -- Blip
        ['blip_label'] = 'Rentals',
        
        -- Target
        ['target_label'] = 'Rent Vehicle',
        
        -- Error messages
        ['invalid_rental_data'] = 'ld-rentals: invalid rental data'
    }
}

-- Helper function to get localized text
function _U(str, ...)
    local lang = Config.Language or 'bg'
    local text = Locales[lang] and Locales[lang][str] or str
    
    if ... then
        return string.format(text, ...)
    end
    
    return text
end
