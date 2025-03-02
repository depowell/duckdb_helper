-- models/demo_date_spline.sql
{{
    config(
        post_hook="""
            {{ copy_to_csv(this, './demo_date_spline.csv')}}
        """
    )
}}
{{ date_spline('2025-02-28', '2025-03-10') }}
