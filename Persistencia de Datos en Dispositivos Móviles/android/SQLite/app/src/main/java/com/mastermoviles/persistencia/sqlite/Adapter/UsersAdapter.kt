package com.mastermoviles.persistencia.sqlite.Adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.mastermoviles.persistencia.sqlite.Models.Users
import com.mastermoviles.persistencia.sqlite.R

class UsersAdapter(private val users: ArrayList<Users>): RecyclerView.Adapter<UsersAdapter.ViewHolder>() {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view: View = LayoutInflater.from(parent.context).inflate(R.layout.item_user, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.bind(users[position])
    }

    override fun getItemCount(): Int {
        return users.size
    }

    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        var userName: TextView = view.findViewById(R.id.userNameItem)
        var email: TextView = view.findViewById(R.id.emailItem)

        fun bind(user: Users) {
            userName.text = user.nombre_usuario
            email.text = user.email
        }
    }
}