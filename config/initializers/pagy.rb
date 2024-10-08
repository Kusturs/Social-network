require 'pagy/extras/metadata'
require 'pagy/extras/headers'

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:metadata] = [:page, :items, :count, :pages, :next, :prev, :last, :from, :to]