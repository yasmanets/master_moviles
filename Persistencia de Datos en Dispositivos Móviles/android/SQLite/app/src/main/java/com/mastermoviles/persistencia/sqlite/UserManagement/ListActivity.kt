package com.mastermoviles.persistencia.sqlite.UserManagement

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import androidx.recyclerview.widget.DefaultItemAnimator
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mastermoviles.persistencia.sqlite.Adapter.UsersAdapter
import com.mastermoviles.persistencia.sqlite.Data.Database
import com.mastermoviles.persistencia.sqlite.Models.Users
import com.mastermoviles.persistencia.sqlite.R

class ListActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list)

        title = "Lista de usuarios"
        val databese = Database(this)
        val users: ArrayList<Users> = databese.getUsers() as ArrayList<Users>

        var recyclerView: RecyclerView = findViewById(R.id.usersList)
        recyclerView.itemAnimator = DefaultItemAnimator()
        var layoutManager: RecyclerView.LayoutManager = LinearLayoutManager(this)
        recyclerView.layoutManager = layoutManager
        val adapter = UsersAdapter(users)
        recyclerView.adapter = adapter

        val back: Button = findViewById(R.id.back)
        back.setOnClickListener { finish() }
    }
}